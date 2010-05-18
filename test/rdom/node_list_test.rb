require File.expand_path('../../test_helper', __FILE__)

class NodeListTest < Test::Unit::TestCase
  attr_reader :window, :document

  def setup
    @window = RDom::Window.new('<html><body><div id="foo">FOO</div><p class="bar">BAR</p></body></html>')
    @document = window.document
  end

  # DOM-Level-1-Core
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html

  test "ruby: item() returns the indexth item in the collection", :ruby, :dom_1_core do
    assert_equal 'P', document.body.childNodes.item(1).nodeName
  end

  test "js: item() returns the indexth item in the collection", :js, :dom_1_core do
    assert_equal 'P', window.evaluate("document.body.childNodes.item(1).nodeName")
  end

  test "ruby: length returns the number of nodes in the list", :ruby, :dom_1_core do
    assert_equal 2, document.body.childNodes.length
  end

  test "js: length returns the number of nodes in the list", :js, :dom_1_core do
    assert_equal 2, window.evaluate("document.body.childNodes.length")
  end
end