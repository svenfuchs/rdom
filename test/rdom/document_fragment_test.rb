require File.expand_path('../../test_helper', __FILE__)

class DocumentFragmentTest < Test::Unit::TestCase
  attr_reader :document, :body
  
  def setup
    html = '<html><body></body></html>'
    @document = RDom::Document.parse(html)
    @body = document.find_first('//body')
  end
  
  test "appending a document fragment to a node", :dom_2_core do
    div = document.createElement('div')
    span = document.createElement('span')
    
    fragment = document.createDocumentFragment
    fragment.appendChild(div)
    fragment.insertBefore(span, div)
    body.appendChild(fragment)
    
    assert_equal %w(SPAN DIV), body.childNodes.map { |child| child.nodeName }
  end
end