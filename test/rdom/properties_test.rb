require File.expand_path('../../test_helper', __FILE__)

class PropertiesTest < Test::Unit::TestCase
  attr_reader :window, :document, :links

  def setup
    @window = RDom::Window.new
    window.load(File.expand_path('../../fixtures/properties.html', __FILE__), :url => 'http://example.org')
    @links = window.evaluate('links = document.getElementsByTagName("a");')
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

  # standard html attribute: title

  test 'js: given the title attribute is set: read via method call syntax returns the attribute value' do
    assert_equal 'foo', window.evaluate('links[0].title')
  end

  test 'js: given the title attribute is set: read via hash access syntax returns the attribute value' do
    assert_equal 'foo', window.evaluate('links[0]["title"]')
  end

  test 'js: given the title attribute is set: getAttribute(attr_name) the attribute value' do
    assert_equal 'foo', window.evaluate('links[0].getAttribute("title")')
  end

  # TODO
  # test 'js: given the title attribute is set: attributes.[attr_name] returns the attribute' do
  #   assert_equal 'foo', window.evaluate('links[0].attributes.title.value')
  # end

  test 'js: given the title attribute is an empty string: read via method call syntax returns an empty string' do
    assert_equal '', window.evaluate('links[1]["title"]')
  end

  test 'js: given the title attribute is an empty string: read via hash access syntax returns an empty string' do
    assert_equal '', window.evaluate('links[1]["title"]')
  end

  test 'js: given the title attribute is an empty string: getAttribute(attr_name) the attribute value' do
    assert_equal '', window.evaluate('links[1].getAttribute("title")')
  end

  # test 'js: given the title attribute is an empty string: attributes.[attr_name] returns the attribute' do
  #   assert_equal '', window.evaluate('links[1].attributes.title.value')
  # end

  test 'js: given the title attribute is not set: read via method call syntax returns an empty string' do
    assert_equal '', window.evaluate('links[2].title')
  end

  test 'js: given the title attribute is not set: read via hash access syntax returns an empty string' do
    assert_equal '', window.evaluate('links[2].title')
  end

  test 'js: given the title attribute is not set: getAttribute(attr_name) returns nil' do
    assert_nil window.evaluate('links[2].getAttribute("title")')
  end

  test 'js: given the title attribute is not set: attributes.[attr_name] returns nil' do
    assert_nil window.evaluate('links[2].attributes.title')
  end

  # standard html attribute, special case: name

  test 'js: given the name attribute is set: read via method call syntax returns the attribute value' do
    assert_equal 'foo', window.evaluate('links[0].name')
  end

  test 'js: given the name attribute is set: read via hash access syntax returns the attribute value' do
    assert_equal 'foo', window.evaluate('links[0]["name"]')
  end

  test 'js: given the name attribute is set: getAttribute(attr_name) the attribute value' do
    assert_equal 'foo', window.evaluate('links[0].getAttribute("name")')
  end

  # test 'js: given the name attribute is set: attributes.[attr_name] returns the attribute' do
  #   assert_equal 'foo', window.evaluate('links[0].attributes.name.value')
  # end

  test 'js: given the name attribute is an empty string: read via method call syntax returns an empty string' do
    assert_equal '', window.evaluate('links[1].name')
  end

  test 'js: given the name attribute is an empty string: read via hash access syntax returns an empty string' do
    assert_equal '', window.evaluate('links[1]["name"]')
  end

  test 'js: given the name attribute is an empty string: getAttribute(attr_name) the attribute value' do
    assert_equal '', window.evaluate('links[1].getAttribute("name")')
  end

  # test 'js: given the name attribute is an empty string: attributes.[attr_name] returns the attribute' do
  #   assert_equal '', window.evaluate('links[1].attributes.name.value')
  # end

  test 'js: given the name attribute is not set: read via method call syntax returns an empty string' do
    assert_equal '', window.evaluate('links[2].name')
  end

  test 'js: given the name attribute is not set: read via hash access syntax returns an empty string' do
    assert_equal '', window.evaluate('links[2].name')
  end

  test 'js: given the name attribute is not set: getAttribute(attr_name) returns nil' do
    assert_nil window.evaluate('links[2].getAttribute("name")')
  end

  test 'js: given the name attribute is not set: attributes.[attr_name] returns nil' do
    assert_nil window.evaluate('links[2].attributes.name')
  end

  # non-standard attribute foo

  test 'js: given an attribute foo is set: read via method call syntax returns nil' do
    assert_nil window.evaluate('links[0].foo')
  end

  test 'js: given an attribute foo is set: read via hash access syntax returns nil' do
    assert_nil window.evaluate('links[0]["foo"]')
  end

  test 'js: given an attribute foo is set: getAttribute(attr_name) the attribute value' do
    assert_equal 'foo', window.evaluate('links[0].getAttribute("foo")')
  end

  test 'js: given an attribute foo is set: attributes.[attr_name] returns nil' do
    assert_nil window.evaluate('links[0].attributes.foo.value')
  end

  test 'js: given an attribute foo is an empty string: read via method call syntax returns nil' do
    assert_nil window.evaluate('links[1].foo')
  end

  test 'js: given an attribute foo is an empty string: read via hash access syntax returns nil' do
    assert_nil window.evaluate('links[1]["foo"]')
  end

  test 'js: given an attribute foo is an empty string: getAttribute(attr_name) an empty string' do
    assert_equal 'foo', window.evaluate('links[0].getAttribute("foo")')
  end

  test 'js: given an attribute foo is an empty string: attributes.[attr_name] returns nil' do
    assert_nil window.evaluate('links[0].attributes.foo.value')
  end

  test 'js: given an attribute foo is not set: read via method call syntax returns nil' do
    assert_nil window.evaluate('links[2].foo')
  end

  test 'js: given an attribute foo is not set: read via hash access syntax returns nil' do
    assert_nil window.evaluate('links[2]["foo"]')
  end

  test 'js: given an attribute foo is not set: getAttribute(attr_name) returns nil' do
    assert_nil window.evaluate('links[2].getAttribute("name")')
  end

  test 'js: given an attribute foo is not set: attributes.[attr_name] returns nil' do
    assert_nil window.evaluate('links[2].attributes.name')
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

  test 'js: given the class attribute is set: read via method call syntax to className returns the attribute value' do
    assert_equal 'foo', window.evaluate('links[0].className')
  end

  test 'js: given the class attribute is set: read via hash access syntax to className returns the attribute value' do
    assert_equal 'foo', window.evaluate('links[0]["className"]')
  end

  test 'js: given the class attribute is set: getAttribute("class") returns the attribute value' do
    assert_equal 'foo', window.evaluate('links[0].getAttribute("class")')
  end

  # test 'js: given the class attribute is set: attributes["class"] returns the attribute' do
  #   assert_equal 'foo', window.evaluate('links[0].attributes.class.value')
  # end

  test 'js: given the class attribute is an empty string: read via method call syntax returns an empty string' do
    assert_equal '', window.evaluate('links[1].className')
  end

  test 'js: given the class attribute is an empty string: read via hash access syntax returns an empty string' do
    assert_equal '', window.evaluate('links[1]["className"]')
  end

  test 'js: given the class attribute is an empty string: getAttribute(class) the attribute value' do
    assert_equal '', window.evaluate('links[1].getAttribute("class")')
  end

  # test 'js: given the class attribute is an empty string: attributes.class returns the attribute' do
  #   assert_equal '', window.evaluate('links[1].attributes.class.value')
  # end

  test 'js: given the class attribute is not set: read via method call syntax returns an empty string' do
    assert_equal '', window.evaluate('links[2].className')
  end

  test 'js: given the class attribute is not set: read via hash access syntax returns an empty string' do
    assert_equal '', window.evaluate('links[2]["className"]')
  end

  test 'js: given the class attribute is not set: getAttribute("class") returns nil' do
    assert_nil window.evaluate('links[2].getAttribute("class")')
  end

  test 'js: given the class attribute is not set: attributes.class returns nil' do
    assert_nil window.evaluate('links[2].attributes.class.value')
  end

  # # test "a document has a property :title" do
  # #   window.evaluate 'document.title = "foo"'
  # #   assert_equal 'foo', document.title
  # #   assert_equal 'foo', document.getElementsByTagName('title')[0].content
  # #
  # #   document.title = 'bar'
  # #   assert_equal 'bar', window.evaluate('document.title')
  # #   assert_equal 'bar', window.evaluate('document["title"]')
  # # end
  # #
  # # test 'foo' do
  # #   window.evaluate <<-js
  # #     var div = document.createElement('div');
  # #     div.style.display = 'none'
  # #   js
  # # end
  # #
  # # test "a node has a property :title" do
  # #   assert span.property?(:title)
  # #   span.title = 'foo'
  # #   assert_equal 'foo', span.title
  # #   assert_equal 'foo', span.getAttribute('title')
  # # end
  # #
  # # test "an attribute node has a property :nodeType" do
  # #   # assert anchor.getAttributeNode(:href).property?(:nodeType) # TODO!
  # #   assert document.createAttribute(:href).property?(:nodeType)
  # # end
  # #
  # # test "a span element has a property :id" do
  # #   assert_has_property(span, :id)
  # # end
  # #
  # # test "a span element does not have a property :href" do
  # #   assert_does_not_have_property(span, :href)
  # # end
  # #
  # # test "an anchor element has a property :id" do
  # #   assert_has_property(anchor, :id)
  # # end
  # #
  # # test "an anchor element has a property :href" do
  # #   assert_has_property(anchor, :href)
  # # end
  # #
  # # test "special attribute className is called class in HTML (set using . from ruby)" do
  # #   span.className = 'bar'
  # #   assert_equal 'bar', span.className
  # #   assert_equal 'bar', span.getAttribute('class')
  # #   assert_equal '<span id="foo" class="bar"/>', span.to_s
  # # end
  # #
  # # test "special attribute className is called class in HTML (set using [] from ruby)" do
  # #   span['className'] = 'bar'
  # #   assert_equal 'bar', span.className
  # #   assert_equal 'bar', span.getAttribute('class')
  # #   assert_equal '<span id="foo" class="bar"/>', span.to_s
  # # end
  # #
  # # test "special attribute className is called class in HTML (set using . from js)" do
  # #   window.evaluate 'document.getElementsByTagName("span")[0].className = "bar"'
  # #   assert_equal 'bar', span.className
  # #   assert_equal 'bar', span.getAttribute('class')
  # #   assert_equal '<span id="foo" class="bar"/>', span.to_s
  # # end
  # #
  # # test "special attribute className is called class in HTML (set using [] from js)" do
  # #   window.evaluate 'document.getElementsByTagName("span")[0]["className"] = "bar"'
  # #   assert_equal 'bar', span.className
  # #   assert_equal 'bar', span.getAttribute('class')
  # #   assert_equal '<span id="foo" class="bar"/>', span.to_s
  # # end
  # #
  # # test "window.location.search" do
  # #   assert_equal 'example.org', window.evaluate('window.location.hostname')
  # # end
  # #
  # # def assert_has_property(node, name)
  # #   assert node.js_property?(name)
  # #   node.send(:"#{name}=", name)
  # #   assert_equal name.to_s, node.send(name)
  # # end
  # #
  # # def assert_does_not_have_property(node, name)
  # #   assert !node.js_property?(name)
  # # end
end