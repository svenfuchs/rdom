require File.expand_path('../../test_helper', __FILE__)

class AttributesTest < Test::Unit::TestCase
  attr_reader :window, :document, :body, :div

  def setup
    @window = RDom::Window.new('<html><body><div id="foo">FOO</div></body></html>')
    @document = window.document
    @div = document.getElementsByTagName('//div').first
    window.evaluate("var div = document.getElementsByTagName('div')[0];")
  end

  # DOM-Level-1-Core
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html

  test "ruby: getNamedItem() retrieves a node specified by name", :ruby, :dom_1_core do
    assert_equal 'foo', div.attributes.getNamedItem('id').value
  end

  test "js: getNamedItem() retrieves a node specified by name", :js, :dom_1_core do
    assert_equal 'foo', window.evaluate("div.attributes.getNamedItem('id').value")
  end

  test "ruby: setNamedItem() adds a node using its nodeName attribute", :ruby, :dom_1_core do
    attribute = document.createAttribute('title')
    attribute.value = 'bar'
    div.attributes.setNamedItem(attribute)
    assert_equal 'bar', div.title
  end

  test "js: setNamedItem() adds a node using its nodeName attribute", :js, :dom_1_core do
    window.evaluate <<-js
      attribute = document.createAttribute('title')
      attribute.value = 'bar'
      div.attributes.setNamedItem(attribute)
    js
    assert_equal 'bar', window.evaluate("div.title")
  end

  test "ruby: removeNamedItem() removes a node specified by name. If the removed node is an Attr with a default value it is immediately replaced", :ruby, :dom_1_core do
    div.attributes.removeNamedItem('id')
    assert !div.hasAttribute('id')
  end

  test "js: removeNamedItem() removes a node specified by name. If the removed node is an Attr with a default value it is immediately replaced", :js, :dom_1_core do
    window.evaluate("div.attributes.removeNamedItem('id')")
    assert !window.evaluate("div.hasAttribute('id')")
  end

  test "ruby: item() returns the indexth item in the map. If index is greater than or equal to the number of nodes in the map, this returns null", :ruby, :dom_1_core do
    assert_equal 'foo', div.attributes.item(0).value
  end

  test "js: item() returns the indexth item in the map. If index is greater than or equal to the number of nodes in the map, this returns null", :js, :dom_1_core do
    assert_equal 'foo', window.evaluate("div.attributes.item(0).value")
  end

  test "ruby: length returns the number of nodes in the list", :ruby, :dom_1_core do
    assert_equal 1, div.attributes.length
  end

  test "js: length returns the number of nodes in the list", :js, :dom_1_core do
    assert_equal 1, window.evaluate("div.attributes.length")
  end
end