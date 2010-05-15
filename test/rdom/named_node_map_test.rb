require File.expand_path('../../test_helper', __FILE__)

class NamedNodeMapTest < Test::Unit::TestCase
  attr_reader :document, :body, :div

  def setup
    html = '<html><body><div id="foo">FOO</div></body></html>'
    @document = LibXML::XML::HTMLParser.string(html).parse
    @div = document.find_first('//div')
  end

  # DOM-Level-1-Core
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html

  test "getNamedItem() retrieves a node specified by name", :dom_1_core do
    assert_equal 'foo', div.attributes.getNamedItem('id').value
  end

  test "setNamedItem() adds a node using its nodeName attribute", :dom_1_core do
    attribute = document.createAttribute('title')
    attribute.value = 'bar'
    div.attributes.setNamedItem(attribute)
    assert_equal 'bar', div.title
  end

  test "removeNamedItem() removes a node specified by name. If the removed node is an Attr with a default value it is immediately replaced", :dom_1_core do
    div.attributes.removeNamedItem('id')
    assert !div.hasAttribute('id')
  end

  test "item() returns the indexth item in the map. If index is greater than or equal to the number of nodes in the map, this returns null", :dom_1_core do
    assert_equal 'foo', div.attributes.item(0).value
  end

  test "length returns the number of nodes in the list", :dom_1_core do
    assert_equal 1, div.attributes.length
  end
end