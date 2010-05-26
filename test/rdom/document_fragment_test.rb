require File.expand_path('../../test_helper', __FILE__)

class DocumentFragmentTest < Test::Unit::TestCase
  attr_reader :window, :document, :body

  def setup
    @window = RDom::Window.new('<html><body></body></html>')
    @document = window.document
    @body = document.getElementsByTagName('//body').first
  end

  test "ruby: appending a document fragment to a node", :ruby, :dom_2_core do
    div = document.createElement('div')
    span = document.createElement('span')

    fragment = document.createDocumentFragment
    fragment.appendChild(div)
    fragment.insertBefore(span, div)
    body.appendChild(fragment)

    assert_equal %w(SPAN DIV), body.childNodes.map { |child| child.nodeName }
  end

  test "js: appending a document fragment to a node", :js, :dom_2_core do
    window.evaluate <<-js
      body = document.body
      div = document.createElement('div')
      span = document.createElement('span')

      fragment = document.createDocumentFragment()
      fragment.appendChild(div)
      fragment.insertBefore(span, div)
      body.appendChild(fragment)
    js
    assert_equal %w(SPAN DIV), window.evaluate("[body.firstChild.nodeName, body.lastChild.nodeName]").to_a
  end
end