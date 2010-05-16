require File.expand_path('../../test_helper', __FILE__)

class PropertiesTest < Test::Unit::TestCase
  attr_reader :window, :document, :anchor, :span

  def setup
    @window = RDom::Window.new
    window.load('<html><head><title></title></head><body><span id="foo"></span><a href=""></a></body></html>', 'http://example.org')
    @document = @window.document
    @anchor = document.find_first('//a')
    @span = document.find_first('//span')
  end

  test "defines implicit attr_accessors on write from js" do
    window.evaluate 'document.getElementsByTagName("a")[0].foo = "bar";'
    assert_equal 'bar', document.getElementsByTagName("a")[0].foo
    assert_equal 'bar', document.getElementsByTagName("a")[0]['foo']
    assert_equal '<a href=""/>', document.getElementsByTagName('a')[0].to_s;
  end

  test "defines implicit attr_accessors on read from js" do
    assert_nil window.evaluate 'document.getElementsByTagName("a")[0].foo;'
    # nope. not doing this for attr read on the ruby side right now
    # assert_equal nil, document.getElementsByTagName('a')[0].foo
    # assert_equal nil, document.getElementsByTagName('a')[0]['foo']
    # assert_equal '<a href=""/>', document.getElementsByTagName('a')[0].to_s;
  end

  test "html element attribute values written using . show up in the markup" do
    window.evaluate 'document.getElementsByTagName("a")[0].href = "bar"'
    assert_equal 'bar', document.getElementsByTagName('a')[0].href
    assert_equal 'bar', document.getElementsByTagName('a')[0]['href']
    assert_equal '<a href="bar"/>', document.getElementsByTagName('a')[0].to_s;
  end

  test "html element attribute values written using [] show up in the markup" do
    window.evaluate 'document.getElementsByTagName("a")[0]["href"] = "bar"'
    assert_equal 'bar', document.getElementsByTagName('a')[0].href
    assert_equal 'bar', document.getElementsByTagName('a')[0]['href']
    assert_equal '<a href="bar"/>', document.getElementsByTagName('a')[0].to_s;
  end

  test "a document has a property :title" do
    window.evaluate 'document.title = "foo"'
    assert_equal 'foo', document.title
    assert_equal 'foo', document.getElementsByTagName('title')[0].content
    
    document.title = 'bar'
    assert_equal 'bar', window.evaluate('document.title')
    assert_equal 'bar', window.evaluate('document["title"]')
  end
  
  test 'foo' do
    window.evaluate <<-js
      var div = document.createElement('div');
      div.style.display = 'none'
    js
  end

  test "a node has a property :title" do
    assert span.property?(:title)
    span.title = 'foo'
    assert_equal 'foo', span.title
    assert_equal 'foo', span.getAttribute('title')
  end
  
  test "an attribute node has a property :nodeType" do
    # assert anchor.getAttributeNode(:href).property?(:nodeType) # TODO!
    assert document.createAttribute(:href).property?(:nodeType)
  end
  
  test "a span element has a property :id" do
    assert_has_property(span, :id)
  end
  
  test "a span element does not have a property :href" do
    assert_does_not_have_property(span, :href)
  end
  
  test "an anchor element has a property :id" do
    assert_has_property(anchor, :id)
  end
  
  test "an anchor element has a property :href" do
    assert_has_property(anchor, :href)
  end

  test "special attribute className is called class in HTML (set using . from ruby)" do
    span.className = 'bar'
    assert_equal 'bar', span.className
    assert_equal 'bar', span.getAttribute('class')
    assert_equal '<span id="foo" class="bar"/>', span.to_s
  end
  
  test "special attribute className is called class in HTML (set using [] from ruby)" do
    span['className'] = 'bar'
    assert_equal 'bar', span.className
    assert_equal 'bar', span.getAttribute('class')
    assert_equal '<span id="foo" class="bar"/>', span.to_s
  end
  
  test "special attribute className is called class in HTML (set using . from js)" do
    window.evaluate 'document.getElementsByTagName("span")[0].className = "bar"'
    assert_equal 'bar', span.className
    assert_equal 'bar', span.getAttribute('class')
    assert_equal '<span id="foo" class="bar"/>', span.to_s
  end
  
  test "special attribute className is called class in HTML (set using [] from js)" do
    window.evaluate 'document.getElementsByTagName("span")[0]["className"] = "bar"'
    assert_equal 'bar', span.className
    assert_equal 'bar', span.getAttribute('class')
    assert_equal '<span id="foo" class="bar"/>', span.to_s
  end
  
  test "window.location.search" do
    assert_equal 'example.org', window.evaluate('window.location.hostname')
  end
  
  def assert_has_property(node, name)
    assert node.js_property?(name)
    node.send(:"#{name}=", name)
    assert_equal name.to_s, node.send(name)
  end
  
  def assert_does_not_have_property(node, name)
    assert !node.js_property?(name)
  end
end