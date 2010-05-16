require File.expand_path('../../test_helper', __FILE__)

class DocumentTest < Test::Unit::TestCase
  attr_reader :document, :body, :div

  def setup
    html = <<-html
      <html>
        <head>
          <title>title</title>
        </head>
        <body>
          <div id="foo">FOO</div>
          <p class="bar">BAR</p>
          <form><input name="text"/></form>
          <a href="#"></a><a name="foo"></a>
          <img>
          <map><area href="foo.htm" /><area /></map>
        </body>
      </html>
    html
    @window = RDom::Window.new
    @document = RDom::Document.new(@window, html, :url => 'http://example.org', :referrer => 'http://referrer.com')
    @body = document.find_first('//body')
    @div = document.find_first('//div')
  end
  
  test "document.location returns the URI of the current document", :dom_0, :non_standard do
    assert_equal RDom::Location, document.location.class
  end

  # DOM-Level-1-Core do
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html do
  test "document.createElement creates a new element with the given tag name", :dom_1_core do
    node = document.createElement('div')
    assert_equal '<div/>', node.to_s
    assert_equal document, node.ownerDocument
    assert_equal XML::Node::ELEMENT_NODE, node.nodeType
  end

  test "document.createDocumentFragment creates a new document fragment", :dom_1_core do
    node = document.createDocumentFragment
    assert_equal XML::Node::DOCUMENT_FRAG_NODE, node.nodeType
  end

  test "document.createTextNode creates a text node", :dom_1_core do
    node = document.createTextNode('text')
    assert_equal 'text', node.to_s
    assert_equal XML::Node::TEXT_NODE, node.nodeType
  end

  test "document.createComment creates a new comment node and returns it", :dom_1_core do
    node = document.createComment('comment')
    assert_equal '<!--comment-->', node.to_s
    assert_equal XML::Node::COMMENT_NODE, node.nodeType
  end

  test "document.createAttribute creates a new attribute node and returns it", :dom_1_core do
    node = document.createAttribute('foo')
    assert_equal XML::Node::ATTRIBUTE_NODE, node.nodeType
  end

  test "document.getElementsByTagName returns a list of elements with the given tag name", :dom_1_core do
    nodes = document.getElementsByTagName('div')
    assert_equal 1, nodes.size
    assert_equal '<div id="foo">FOO</div>', nodes.map { |node| node.to_s }.join
  end

  # DOM-Level-1-Html do
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-html.html do

  test "document.getElementById returns an object reference to the identified element", :dom_1_html, :dom_2_core do
    node = document.getElementById('foo')
    assert_equal '<div id="foo">FOO</div>', node.to_s
  end

  test "document.getElementsByName returns a list of elements with the given name", :dom_1_html do
    node = document.getElementsByName('text')
    assert_equal '<input name="text"/>', node.to_s
  end
  
  test "document.title returns the title of the current document", :dom_1_html do
    assert_equal 'title', document.title
  end

  test "document.domain returns the domain of the current document", :html do
    assert_equal 'example.org', document.domain
  end

  test "document.URL returns a string containing the URL of the current document", :dom_1_html do
    assert_equal 'http://example.org', document.URL
  end

  test "document.referrer returns the URI of the page that linked to this page", :dom_1_html do
    assert_equal 'http://referrer.com', document.referrer
  end

  test "document.body returns the BODY node of the current document", :dom_1_html do
    assert_equal 'BODY', document.body.nodeName
  end

  test "document.images returns a list of the images in the current document", :dom_1_html do
    assert_equal %w(IMG), document.images.map { |node| node.nodeName }
  end

  test "document.links returns a list of all the hyperlinks in the document", :dom_1_html do
    assert_equal %w(A AREA), document.links.map { |node| node.nodeName }
  end

  test "document.forms returns a list of the FORM elements within the current document", :dom_1_html do
    assert_equal %w(FORM), document.forms.map { |node| node.nodeName }
  end

  test "document.anchors returns a list of all of the anchors in the document", :dom_1_html do
    assert_equal %w(A), document.anchors.map { |node| node.nodeName }
  end

  # test "document.cookie returns a semicolon-separated list of the cookies for that document or sets a single cookie", :dom_1_html do
  #   flunk('not implemented')
  # end
  # 
  # test "document.open open a document stream for writing (if a document exists in the target, this method clears it)", :dom_1_html do
  #   flunk('not implemented')
  # end
  # 
  # test "document.close closes a document stream", :dom_1_html do
  #   flunk('not implemented')
  # end
  # 
  # test "document.write writes a string of text to a document stream", :dom_1_html do
  #   flunk('not implemented')
  # end
  # 
  # test "document.writeln writes a string of text followed by a newline character to a document stream", :dom_1_html do
  #   flunk('not implemented')
  # end

  # DOM-Level-2-Core do
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Core-20001113/core.html#i-Document do
  # test "document.doctype returns the Document Type Definition (DTD) of the current document", :dom_2_core do
  #   flunk('not implemented')
  # end
  # 
  # test "document.implementation returns the DOM implementation associated with the current document", :dom_2_core do
  #   flunk('not implemented')
  # end

  test "document.documentElement returns the Element that is a direct child of document", :dom_2_core do
    assert_equal 'HTML', document.documentElement.nodeName
  end

  test "document.importNode returns a clone of a node from an external document", :dom_2_core do
    html  = '<span>span</span>'
    other = RDom::Document.parse(html)
    span  = other.getElementsByTagName('span').first
    clone = document.importNode(span)
    
    assert_equal html, clone.to_s
    assert clone.object_id != span.object_id
  end

  # test "document.createElementNS creates a new element with the given tag name and namespace URI", :dom_2_core do
  #   flunk('not implemented')
  # end
  # 
  # test "document.createAttributeNS creates a new attribute node in a given namespace and returns it", :dom_2_core do
  #   flunk('not implemented')
  # end
  # 
  # test "document.getElementsByTagNameNS returns a list of elements with the given tag name and namespace", :dom_2_core do
  #   flunk('not implemented')
  # end

  # DOM-Level-2-Events do
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Events-20001113/events.html do
  test "document.addEventListener adds an event listener to the document", :dom_2_events do
    triggered = []
    listener  = lambda { |event| triggered << event.currentTarget.nodeName }
    event     = document.createEvent('MouseEvents').initEvent('click')

    document.addEventListener('click', listener)
    document.dispatchEvent(event)

    assert_equal ['#document'], triggered
  end

  test "document.removeEventListener removes an event listener from the document", :dom_2_events do
    triggered = []
    listener  = lambda { |event| triggered << event.currentTarget.nodeName }
    event     = document.createEvent('MouseEvents').initEvent('click')

    document.addEventListener('click', listener)
    document.removeEventListener('click', listener)
    document.dispatchEvent(event)

    assert_equal [], triggered
  end

  test "document.dispatchEvent allows the dispatch of events into the implementations event model", :dom_2_events do
    # tested above
    assert document.respond_to?(:dispatchEvent)
  end

  test "document.createEvent creates an event", :dom_2_events do
    # tested above
    assert document.respond_to?(:createEvent)
  end

  # DOM-Level-2-Style do
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Style-20001113/stylesheets.html#StyleSheets-extensions do
  test "document.styleSheets returns a list of the stylesheet objects on the current document", :dom_2_style do
  end

  # DOM-Level-2-Views do
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Views-20001113/views.html do
  test "document.defaultView returns a reference to the window object", :dom_2_view do
    assert_equal RDom::Window, document.defaultView.class
  end
end