require File.expand_path('../../test_helper', __FILE__)

class NodeListTest < Test::Unit::TestCase
  attr_reader :document, :body, :div

  def setup
    html = '<html><body><div id="foo">FOO</div><p class="bar">BAR</p></body></html>'
    @document = RDom::Document.parse(html)
    @body = document.find_first('//body')
  end

  # DOM-Level-1-Core
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html

  test "item() returns the indexth item in the collection", :dom_1_core do
    assert_equal 'P', body.childNodes.item(1).nodeName
  end

  test "length returns the number of nodes in the list", :dom_1_core do
    assert_equal 2, body.childNodes.length
  end
end