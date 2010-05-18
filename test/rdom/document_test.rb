require File.expand_path('../../test_helper', __FILE__)

class DocumentTest < Test::Unit::TestCase
  attr_reader :window, :document, :body, :div

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
    @window = RDom::Window.new(html, :url => 'http://example.org', :referrer => 'http://referrer.com')
    @document = window.document
    @body = document.find_first('//body')
    @div = document.find_first('//div')
  end

  test "ruby: setting document.title implicitely creates head and title tags", :ruby, :dom_0, :no_standard do
    window.load("<html></html>")
    window.document.title = "foo"
    assert_equal 'foo', window.document.getElementsByTagName('title')[0].textContent
  end

  test "ruby: document.location returns the URI of the current document", :ruby, :dom_0, :no_standard do
    assert_equal RDom::Location, document.location.class
  end

  test "js: document.location returns the URI of the current document", :js, :dom_0, :no_standard do
    assert_equal RDom::Location, window.evaluate('document.location').class
  end

  # DOM-Level-1-Core do
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html do
  test "ruby: document.createElement creates a new element with the given tag name", :ruby, :dom_1_core do
    node = document.createElement('div')
    assert_equal '<div/>', node.to_s
    assert_equal document, node.ownerDocument
    assert_equal XML::Node::ELEMENT_NODE, node.nodeType
  end

  test "js: document.createElement creates a new element with the given tag name", :js, :dom_1_core do
    window.evaluate('var node = document.createElement("div")')
    assert_equal '<div/>', window.evaluate('node').to_s
    assert_equal document, window.evaluate('node.ownerDocument')
    assert_equal XML::Node::ELEMENT_NODE, window.evaluate('node.nodeType')
  end

  test "ruby: document.createDocumentFragment creates a new document fragment", :ruby, :dom_1_core do
    node = document.createDocumentFragment
    assert_equal XML::Node::DOCUMENT_FRAG_NODE, node.nodeType
  end

  test "js: document.createDocumentFragment creates a new document fragment", :js, :dom_1_core do
    window.evaluate('var node = document.createDocumentFragment()')
    assert_equal XML::Node::DOCUMENT_FRAG_NODE, window.evaluate('node.nodeType')
  end

  test "ruby: document.createTextNode creates a text node", :ruby, :dom_1_core do
    node = document.createTextNode('text')
    assert_equal 'text', node.to_s
    assert_equal XML::Node::TEXT_NODE, node.nodeType
  end

  test "js: document.createTextNode creates a text node", :js, :dom_1_core do
    window.evaluate("node = document.createTextNode('text')")
    assert_equal 'text', window.evaluate('node').to_s
    assert_equal XML::Node::TEXT_NODE, window.evaluate('node.nodeType')
  end

  test "ruby: document.createComment creates a new comment node and returns it", :ruby, :dom_1_core do
    node = document.createComment('comment')
    assert_equal '<!--comment-->', node.to_s
    assert_equal XML::Node::COMMENT_NODE, node.nodeType
  end

  test "js: document.createComment creates a new comment node and returns it", :js, :dom_1_core do
    window.evaluate("node = document.createComment('comment')")
    assert_equal '<!--comment-->', window.evaluate("node").to_s
    assert_equal XML::Node::COMMENT_NODE, window.evaluate("node.nodeType")
  end

  test "ruby: document.createAttribute creates a new attribute node and returns it", :ruby, :dom_1_core do
    node = document.createAttribute('foo')
    assert_equal XML::Node::ATTRIBUTE_NODE, node.nodeType
  end

  test "js: document.createAttribute creates a new attribute node and returns it", :js, :dom_1_core do
    window.evaluate("node = document.createAttribute('foo')")
    assert_equal XML::Node::ATTRIBUTE_NODE, window.evaluate('node.nodeType')
  end

  test "ruby: document.getElementsByTagName returns a list of elements with the given tag name", :ruby, :dom_1_core do
    nodes = document.getElementsByTagName('div')
    assert_equal 1, nodes.size
    assert_equal '<div id="foo">FOO</div>', nodes.map { |node| node.to_s }.join
  end

  test "js: document.getElementsByTagName returns a list of elements with the given tag name", :js, :dom_1_core do
    window.evaluate("nodes = document.getElementsByTagName('div')")
    assert_equal 1, window.evaluate("nodes.length")
    assert_equal '<div id="foo">FOO</div>', window.evaluate("nodes[0]").to_s
  end

  # DOM-Level-1-Html do
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-html.html do

  test "ruby: document.getElementById returns an object reference to the identified element", :ruby, :dom_1_html, :dom_2_core do
    node = document.getElementById('foo')
    assert_equal '<div id="foo">FOO</div>', node.to_s
  end

  test "js: document.getElementById returns an object reference to the identified element", :js, :dom_1_html, :dom_2_core do
    window.evaluate("node = document.getElementById('foo')")
    assert_equal '<div id="foo">FOO</div>', window.evaluate("node").to_s
  end

  test "ruby: document.getElementsByName returns a list of elements with the given name", :ruby, :dom_1_html do
    node = document.getElementsByName('text')
    assert_equal '<input name="text"/>', node.to_s
  end

  test "js: document.getElementsByName returns a list of elements with the given name", :js, :dom_1_html do
    window.evaluate("node = document.getElementsByName('text')")
    assert_equal '<input name="text"/>', window.evaluate("node").to_s
  end

  test "ruby: document.title returns the title of the current document", :ruby, :dom_1_html do
    assert_equal 'title', document.title
  end

  test "js: document.title returns the title of the current document", :js, :dom_1_html do
    assert_equal 'title', window.evaluate("document.title")
  end

  test "ruby: document.domain returns the domain of the current document", :ruby, :html do
    assert_equal 'example.org', document.domain
  end

  test "js: document.domain returns the domain of the current document", :js, :html do
    assert_equal 'example.org', window.evaluate("document.domain")
  end

  test "ruby: document.URL returns a string containing the URL of the current document", :ruby, :dom_1_html do
    assert_equal 'http://example.org', document.URL
  end

  test "js: document.URL returns a string containing the URL of the current document", :js, :dom_1_html do
    assert_equal 'http://example.org', window.evaluate("document.URL")
  end

  test "ruby: document.referrer returns the URI of the page that linked to this page", :ruby, :dom_1_html do
    assert_equal 'http://referrer.com', document.referrer
  end

  test "js: document.referrer returns the URI of the page that linked to this page", :js, :dom_1_html do
    assert_equal 'http://referrer.com', window.evaluate("document.referrer")
  end

  test "ruby: document.body returns the BODY node of the current document", :ruby, :dom_1_html do
    assert_equal 'BODY', document.body.nodeName
  end

  test "js: document.body returns the BODY node of the current document", :js, :dom_1_html do
    assert_equal 'BODY', window.evaluate("document.body.nodeName")
  end

  test "ruby: document.images returns a list of the images in the current document", :ruby, :dom_1_html do
    assert_equal %w(IMG), document.images.map { |node| node.nodeName }
  end

  test "js: document.images returns a list of the images in the current document", :js, :dom_1_html do
    assert_equal %w(IMG), window.evaluate("[document.images[0].nodeName]").to_a
  end

  test "ruby: document.links returns a list of all the hyperlinks in the document", :ruby, :dom_1_html do
    assert_equal %w(A AREA), document.links.map { |node| node.nodeName }
  end

  test "js: document.links returns a list of all the hyperlinks in the document", :js, :dom_1_html do
    assert_equal %w(A AREA), window.evaluate("[document.links[0].nodeName, document.links[1].nodeName]") .to_a
  end

  test "ruby: document.forms returns a list of the FORM elements within the current document", :ruby, :dom_1_html do
    assert_equal %w(FORM), document.forms.map { |node| node.nodeName }
  end

  test "js: document.forms returns a list of the FORM elements within the current document", :js, :dom_1_html do
    assert_equal %w(FORM), window.evaluate("[document.forms[0].nodeName]").to_a
  end

  test "ruby: document.anchors returns a list of all of the anchors in the document", :ruby, :dom_1_html do
    assert_equal %w(A), document.anchors.map { |node| node.nodeName }
  end

  test "js: document.anchors returns a list of all of the anchors in the document", :js, :dom_1_html do
    assert_equal %w(A), window.evaluate("[document.anchors[0].nodeName]").to_a
  end

  # test "ruby: document.cookie returns a semicolon-separated list of the cookies for that document or sets a single cookie", :ruby, :dom_1_html do
  #   flunk('not implemented')
  # end
  #
  # test "ruby: document.open open a document stream for writing (if a document exists in the target, this method clears it)", :ruby, :dom_1_html do
  #   flunk('not implemented')
  # end
  #
  # test "ruby: document.close closes a document stream", :ruby, :dom_1_html do
  #   flunk('not implemented')
  # end
  #
  # test "ruby: document.write writes a string of text to a document stream", :ruby, :dom_1_html do
  #   flunk('not implemented')
  # end
  #
  # test "ruby: document.writeln writes a string of text followed by a newline character to a document stream", :ruby, :dom_1_html do
  #   flunk('not implemented')
  # end

  # DOM-Level-2-Core do
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Core-20001113/core.html#i-Document do
  # test "ruby: document.doctype returns the Document Type Definition (DTD) of the current document", :dom_2_core do
  #   flunk('not implemented')
  # end
  #
  # test "ruby: document.implementation returns the DOM implementation associated with the current document", :dom_2_core do
  #   flunk('not implemented')
  # end

  test "ruby: document.documentElement returns the Element that is a direct child of document", :ruby, :dom_2_core do
    assert_equal 'HTML', document.documentElement.nodeName
  end

  # test "js: document.documentElement returns the Element that is a direct child of document", :js, :dom_2_core do
  #   assert_equal 'HTML', document.documentElement.nodeName
  # end

  test "ruby: document.importNode returns a clone of a node from an external document", :ruby, :dom_2_core do
    html  = '<span>span</span>'
    other = RDom::Document.parse(html)
    span  = other.getElementsByTagName('span').first
    clone = document.importNode(span)

    assert_equal html, clone.to_s
    assert clone.object_id != span.object_id
  end

  # test "ruby: document.createElementNS creates a new element with the given tag name and namespace URI", :ruby, :dom_2_core do
  #   flunk('not implemented')
  # end
  #
  # test "ruby: document.createAttributeNS creates a new attribute node in a given namespace and returns it", :ruby, :dom_2_core do
  #   flunk('not implemented')
  # end
  #
  # test "ruby: document.getElementsByTagNameNS returns a list of elements with the given tag name and namespace", :ruby, :dom_2_core do
  #   flunk('not implemented')
  # end

  # DOM-Level-2-Events do
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Events-20001113/events.html do
  test "ruby: document.addEventListener adds an event listener to the document", :ruby, :dom_2_events do
    triggered = []
    listener  = lambda { |event| triggered << event.currentTarget.nodeName }
    event     = document.createEvent('MouseEvents').initEvent('click')

    document.addEventListener('click', listener)
    document.dispatchEvent(event)

    assert_equal ['#document'], triggered
  end

  test "js: document.addEventListener adds an event listener to the document", :js, :dom_2_events do
    window.evaluate <<-js
      var triggered = [];
      var listener  = { handleEvent: function(event) { triggered.push(event.currentTarget.nodeName) } };
      var event     = document.createEvent('MouseEvents').initEvent('click');

      document.addEventListener('click', listener);
      document.dispatchEvent(event);
    js
    assert_equal ['#document'], window.evaluate("triggered").to_a
  end

  test "ruby: document.removeEventListener removes an event listener from the document", :ruby, :dom_2_events do
    triggered = []
    listener  = lambda { |event| triggered << event.currentTarget.nodeName }
    event     = document.createEvent('MouseEvents').initEvent('click')

    document.addEventListener('click', listener)
    document.removeEventListener('click', listener)
    document.dispatchEvent(event)

    assert_equal [], triggered
  end

  test "js: document.removeEventListener removes an event listener from the document", :js, :dom_2_events do
    window.evaluate <<-js
      var triggered = [];
      var listener  = { handleEvent: function(event) { triggered.push(event.currentTarget.nodeName) } };
      var event     = document.createEvent('MouseEvents').initEvent('click');

      document.addEventListener('click', listener);
      document.removeEventListener('click', listener)
      document.dispatchEvent(event);
    js
    assert_equal [], window.evaluate("triggered").to_a
  end

  test "ruby: document.dispatchEvent allows the dispatch of events into the implementations event model", :ruby, :dom_2_events do
    # tested above
    assert document.respond_to?(:dispatchEvent)
  end

  test "ruby: document.createEvent creates an event", :ruby, :dom_2_events do
    # tested above
    assert document.respond_to?(:createEvent)
  end

  # DOM-Level-2-Style do
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Style-20001113/stylesheets.html#StyleSheets-extensions do
  test "ruby: document.styleSheets returns a list of the stylesheet objects on the current document", :ruby, :dom_2_style do
  end

  # DOM-Level-2-Views do
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Views-20001113/views.html do
  test "ruby: document.defaultView returns a reference to the window object", :ruby, :dom_2_view do
    assert_equal RDom::Window, document.defaultView.class
  end
end