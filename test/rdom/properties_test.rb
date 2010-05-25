require File.expand_path('../../test_helper', __FILE__)

class PropertiesTest < Test::Unit::TestCase
  TEST_ALL_ELEMENTS_PROPERTIES = false

  attr_reader :window, :document, :links

  def setup
    stub_request(:any, /./).to_return { |request| { :body => '' } }

    @window = RDom::Window.new
    window.load(File.expand_path('../../fixtures/properties.html', __FILE__), :url => 'http://example.org')
    window.evaluate('function find_tag(tag_name) { return window.document.getElementsByTagName(tag_name)[0]; }')
    @links = window.evaluate('links = document.getElementsByTagName("a");')
  end

  def find_tag(tag_name)
    window.document.getElementsByTagName(tag_name)[0]
  end

  test "js: attribute values written using . show up in the markup" do
    window.evaluate 'links[0].href = "bar"'
    assert_match /href="bar"/, window.evaluate('links[0].toString()')
  end

  test "js: attribute values written using [] show up in the markup" do
    window.evaluate 'links[0]["href"] = "bar"'
    assert_match /href="bar"/, window.evaluate('links[0].toString()')
  end

  test "js: setting a non-standard property: can be read via method call syntax" do
    assert_equal 'bar', window.evaluate('links[0].bar = "bar"; links[0].bar')
  end

  test "js: setting a non-standard property: can be read via hash access syntax" do
    assert_equal 'bar', window.evaluate('links[0].bar = "bar"; links[0]["bar"]')
  end

  test "js: setting a non-standard property: does not push it into the markup" do
    assert window.evaluate('links[0].bar = "bar"; links[0]') !~ /bar=/
  end

  test "js: reading a non-standard property: can be read via method call syntax" do
    assert_nil window.evaluate('links[0].bar')
  end

  test "js: reading a non-standard property: can be read via hash access syntax" do
    assert_nil window.evaluate('links[0]["bar"]')
  end

  # js_property: nodeName

  test 'js: tag.nodeName returns "A" for <a title="foo"/>' do
    assert_equal 'A', window.evaluate('links[0].nodeName')
  end

  test 'js: tag["nodeName"] returns "A" for <a title="foo"/>' do
    assert_equal 'A', window.evaluate('links[0]["nodeName"]')
  end

  test 'js: tag.getAttribute("nodeName") returns nil' do
    assert_nil window.evaluate('links[0].getAttribute("nodeName")')
  end

  test 'js: tag.attributes.nodeName returns nil' do
    assert_nil window.evaluate('links[0].attributes.nodeName')
  end

  # standard html attributes

  def load_html_tag_with_attribute(tag, attribute = nil, value = nil)
    attribute = "#{attribute}=\"#{value}\"" if attribute
    html = case tag
    when 'head'
      "<html><head #{attribute}></head></html>"
    when 'body'
      "<html><body #{attribute}></body></html>"
    else
      "<html><body><#{tag} #{attribute} /></body></html>"
    end
    window.load(html)
  end

  SKIP_ATTRIBUTES = [:checked, :selected, :readOnly] # these behave differently
  ATTRIBUTE_MAP = {
    :className => 'class',
    :httpEquiv => 'http-equiv',
    :acceptCharset => 'accept-charset'
  }

  def self.test_tags(*tag_names)
    tag_names.each { |tag_name| test_tag(tag_name) }
  end

  def self.test_tag(tag_name)
    attributes = RDom::Element.const_get(tag_name.titleize).ancestors.uniq.map do |const|
      const.const_defined?(:HTML_ATTRIBUTES) ? const.const_get(:HTML_ATTRIBUTES) : []
    end.flatten.uniq
    attributes += [:className]

    attributes.each do |dom_name|
      unless SKIP_ATTRIBUTES.include?(dom_name)
        test_attribute(tag_name, dom_name.to_s, ATTRIBUTE_MAP[dom_name])
      end
    end
  end

  def self.test_attribute(tag_name, dom_name, html_name = nil)
    html_name ||= dom_name.to_s.downcase
    html_value  = 'foo'
    expect_value     = 'foo'
    empty_value      = ''

    if %w(href src).include?(dom_name)
      html_value = "http://example.org/#{html_value}"
      expect_value    = html_value
    elsif dom_name == 'style'
      html_value = 'font-size: 1px;'
      empty_value     = {}
      expect_value    = RDom::Css::StyleDeclaration.new(nil, html_value)
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is set: element.#{dom_name} returns the string value" do
      load_html_tag_with_attribute(tag_name, html_name, html_value)
      assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').#{dom_name}")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is set: element['#{dom_name}'] returns the string value" do
      load_html_tag_with_attribute(tag_name, html_name, html_value)
      assert_equal expect_value, window.evaluate("find_tag('#{tag_name}')['#{dom_name}']")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is set: element.getAttribute('#{html_name}') returns the string value" do
      load_html_tag_with_attribute(tag_name, html_name, html_value)
      assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').getAttribute('#{html_name}')")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is set: element.attributes.#{html_name} returns the attribute" do
      load_html_tag_with_attribute(tag_name, html_name, html_value)
      assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').attributes.#{html_name}").value
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is set: element.attributes['#{html_name}'] returns the attribute" do
      load_html_tag_with_attribute(tag_name, html_name, html_value)
      assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').attributes['#{html_name}']").value
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is an empty string: element.#{dom_name} returns an empty #{empty_value.class.name}" do
      load_html_tag_with_attribute(tag_name, html_name, '')
      assert_equal empty_value, window.evaluate("find_tag('#{tag_name}').#{dom_name}")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is an empty string: element['#{dom_name}'] returns an empty #{empty_value.class.name}" do
      load_html_tag_with_attribute(tag_name, html_name, '')
      assert_equal empty_value, window.evaluate("find_tag('#{tag_name}')['#{dom_name}']")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is an empty string: element.getAttribute('#{html_name}') returns an empty #{empty_value.class.name}" do
      load_html_tag_with_attribute(tag_name, html_name, '')
      assert_equal empty_value, window.evaluate("find_tag('#{tag_name}').getAttribute('#{html_name}')")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is an empty string: element.attributes.#{html_name} returns the attribute" do
      load_html_tag_with_attribute(tag_name, html_name, '')
      assert_equal empty_value, window.evaluate("find_tag('#{tag_name}').attributes.#{html_name}").value
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is an empty string: element.attributes['#{html_name}'] returns the attribute" do
      load_html_tag_with_attribute(tag_name, html_name, '')
      assert_equal empty_value, window.evaluate("find_tag('#{tag_name}').attributes['#{html_name}']").value
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is not set: element.#{dom_name} returns an empty string" do
      load_html_tag_with_attribute(tag_name)
      assert_equal empty_value, window.evaluate("find_tag('#{tag_name}').#{dom_name}")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is not set: element['#{dom_name}'] returns an empty string" do
      load_html_tag_with_attribute(tag_name)
      assert_equal empty_value, window.evaluate("find_tag('#{tag_name}')['#{dom_name}']")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is not set: element.getAttribute('#{html_name}') returns nil" do
      load_html_tag_with_attribute(tag_name)
      assert_nil window.evaluate("find_tag('#{tag_name}').getAttribute('#{html_name}')")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is not set: element.attributes.#{html_name} returns nil" do
      load_html_tag_with_attribute(tag_name)
      assert_nil window.evaluate("find_tag('#{tag_name}').attributes.#{html_name}")
    end

    test "js: #{tag_name} - given the #{dom_name} attribute is not set: element.attributes['#{html_name}'] returns nil" do
      load_html_tag_with_attribute(tag_name)
      assert_nil window.evaluate("find_tag('#{tag_name}').attributes['#{html_name}']")
    end

    # test "ruby: #{tag_name} - given the #{dom_name} attribute is set: element.attributes.#{html_name} returns the attribute" do
    #   assert_equal expect_value, find_tag(tag_name).attributes.send(html_name).value
    # end

    unless dom_name == 'style'
      test "js: #{tag_name} - can set the #{dom_name} attribute using: element.#{dom_name} = #{html_value.inspect}" do
        load_html_tag_with_attribute(tag_name)
        window.evaluate("find_tag('#{tag_name}').#{dom_name} = #{html_value.inspect}")

        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').#{dom_name}")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}')['#{dom_name}']")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').getAttribute('#{html_name}')")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').attributes.#{html_name}").value
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').attributes['#{html_name}']").value
      end

      test "js: #{tag_name} - can set the #{dom_name} attribute using: element['#{dom_name}'] = #{html_value.inspect}" do
        load_html_tag_with_attribute(tag_name)
        window.evaluate("find_tag('#{tag_name}')['#{dom_name}'] = #{html_value.inspect}")

        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').#{dom_name}")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}')['#{dom_name}']")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').getAttribute('#{html_name}')")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').attributes.#{html_name}").value
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').attributes['#{html_name}']").value
      end

      test "js: #{tag_name} - can set the #{dom_name} attribute using: element.setAttribute('#{html_name}', #{html_value.inspect})" do
        load_html_tag_with_attribute(tag_name)
        window.evaluate("find_tag('#{tag_name}').setAttribute('#{html_name}', #{html_value.inspect})")

        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').#{dom_name}")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}')['#{dom_name}']")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').getAttribute('#{html_name}')")
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').attributes.#{html_name}").value
        assert_equal expect_value, window.evaluate("find_tag('#{tag_name}').attributes['#{html_name}']").value
      end
    end
  end

  if TEST_ALL_ELEMENTS_PROPERTIES
    const_names = RDom::Element.constants - %w(ATTRS_CORE ATTRS_I18N ATTRS_EVENTS HTML_ATTRIBUTES)
    test_tags *const_names.map { |name| name.downcase }
  else
    test_tag('a')
  end

  # test_attribute('script', 'src')
  # test_attribute('a', 'className', 'class')
  # test_attribute('a', 'style')


  # using a non-standard attribute

  test "js: a - given the foo attribute is set: element.foo returns nil" do
    load_html_tag_with_attribute('a', 'foo', 'foo')
    assert_nil window.evaluate("find_tag('a').foo")
  end

  test "js: a - given the foo attribute is set: element['foo'] returns nil" do
    load_html_tag_with_attribute('a', 'foo', 'foo')
    assert_nil window.evaluate("find_tag('a')['foo']")
  end

  test "js: a - given the foo attribute is set: element.getAttribute('foo') returns the string value" do
    load_html_tag_with_attribute('a', 'foo', 'foo')
    assert_equal "foo", window.evaluate("find_tag('a').getAttribute('foo')")
  end

  test "js: a - given the foo attribute is set: element.attributes.foo returns the attribute" do
    load_html_tag_with_attribute('a', 'foo', 'foo')
    assert_equal "foo", window.evaluate("find_tag('a').attributes.foo").value
  end

  test "js: a - given the foo attribute is set: element.attributes['foo'] returns the attribute" do
    load_html_tag_with_attribute('a', 'foo', 'foo')
    assert_equal "foo", window.evaluate("find_tag('a').attributes['foo']").value
  end

  test "js: a - given the foo attribute is an empty string: element.foo returns nil" do
    load_html_tag_with_attribute('a', 'foo', '')
    assert_nil window.evaluate("find_tag('a').foo")
  end

  test "js: a - given the foo attribute is an empty string: element['foo'] returns nil" do
    load_html_tag_with_attribute('a', 'foo', '')
    assert_nil window.evaluate("find_tag('a')['foo']")
  end

  test "js: a - given the foo attribute is an empty string: element.getAttribute('foo') returns an empty string" do
    load_html_tag_with_attribute('a', 'foo', '')
    assert_equal "", window.evaluate("find_tag('a').getAttribute('foo')")
  end

  test "js: a - given the foo attribute is an empty string: element.attributes.foo returns the attribute" do
    load_html_tag_with_attribute('a', 'foo', '')
    assert_equal "", window.evaluate("find_tag('a').attributes.foo").value
  end

  test "js: a - given the foo attribute is an empty string: element.attributes['foo'] returns the attribute" do
    load_html_tag_with_attribute('a', 'foo', '')
    assert_equal "", window.evaluate("find_tag('a').attributes['foo']").value
  end

  test "js: a - given the foo attribute is not set: element.foo returns nil" do
    load_html_tag_with_attribute('a')
    assert_nil window.evaluate("find_tag('a').foo")
  end

  test "js: a - given the foo attribute is not set: element['foo'] returns nil" do
    load_html_tag_with_attribute('a')
    assert_nil window.evaluate("find_tag('a')['foo']")
  end

  test "js: a - given the foo attribute is not set: getAttribute('foo') returns nil" do
    load_html_tag_with_attribute('a')
    assert_nil window.evaluate("find_tag('a').getAttribute('foo')")
  end

  test "js: a - given the foo attribute is not set: attributes.foo returns nil" do
    load_html_tag_with_attribute('a')
    assert_nil window.evaluate("find_tag('a').attributes.foo")
  end

  test "js: a - given the foo attribute is not set: attributes['foo'] returns nil" do
    load_html_tag_with_attribute('a')
    assert_nil window.evaluate("find_tag('a').attributes['foo']")
  end

  # special case href
  #
  # test 'js: anchor.href returns "http://example.org/index.html#foo" for <a href="#foo"/>' do
  # end
  #
  # test 'js: anchor["href"] returns "http://example.org/index.html#foo" for <a href="#foo"/>' do
  # end
  #
  # test 'js: anchor.href returns "http://example.org/index.html" for <a href=""/>' do
  # end
  #
  # test 'js: anchor["href"] returns "http://example.org/index.html" for <a href=""/>' do
  # end
  #
  # test 'js: anchor.href returns "" for <a/>' do
  # end
  #
  # test 'js: anchor["href"] returns "" for <a/>' do
  # end
end