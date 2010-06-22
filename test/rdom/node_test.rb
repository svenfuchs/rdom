require File.expand_path('../../test_helper', __FILE__)

class NodeTest < Test::Unit::TestCase
  attr_reader :window, :document, :body, :div

  def setup
    @window = RDom::Window.new('<html><body><div id="foo">FOO</div><p class="bar">BAR</p></body></html>')
    @document = window.document
    @body = document.getElementsByTagName('//body').first
    @div = document.getElementsByTagName('//div').first

    window.evaluate <<-js
      var body = document.body
      var div = document.getElementsByTagName('div')[0]

      function nodeNamesOf(nodes) {
        var names = [];
        for(i = 0; i < nodes.length; i++) { names.push(nodes[i].nodeName); }
        return names;
      }
    js
  end

  # test "ruby: identical nodes obtained from various methods are the same objects", :ruby, :implementation do
  #   assert_equal document.object_id, body.ownerDocument.object_id
  #   assert_equal document.object_id, div.parentNode.ownerDocument.object_id
  #
  #   assert_equal body.object_id, div.parentNode.object_id
  #   assert_equal body.object_id, div.parentNode.lastChild.parentNode.object_id
  # end

  # DOM-Level-1-Core
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html

  test "ruby: Node.nodeName returns the node's name (#document for document)", :ruby, :dom_1_core do
    assert_equal 'DIV', div.nodeName
  end

  test "js: Node.nodeName returns the node's name (#document for document)", :js, :dom_1_core do
    assert_equal 'DIV', window.evaluate("div.nodeName")
  end

  test "ruby: Node.nodeValue returns the node's value (null for document)", :ruby, :dom_1_core do
    window.load <<-html
      <html>
        <body>
          <div>Foo</div>
          <input name="input" value="value">
          <!-- comment -->
        </body>
      </html>
    html

    document = window.document
    input    = document.getElementsByTagName('input')[0]
    div      = document.getElementsByTagName('div')[0]
    comment  = document.body.lastChild

    assert_nil document.nodeValue
    assert_nil div.nodeValue
    assert_nil input.nodeValue
    assert_equal 'input', input.getAttributeNode('name').nodeValue
    assert_equal ' comment ', comment.nodeValue
  end

  test "js: Node.nodeValue returns the node's value (null for document)", :js, :dom_1_core do
    window.load <<-html
      <html>
        <body>
          <div>Foo</div>
          <input name="input" value="value">
          <!-- comment -->
        </body>
      </html>
    html

    window.evaluate <<-js
      document = window.document
      input    = document.getElementsByTagName('input')[0]
      div      = document.getElementsByTagName('div')[0]
      comment  = document.body.lastChild
    js

    assert_nil window.evaluate("document.nodeValue")
    assert_nil window.evaluate("div.nodeValue")
    assert_nil window.evaluate("input.nodeValue")
    assert_equal 'input', window.evaluate("input.getAttributeNode('name').nodeValue")
    assert_equal ' comment ', window.evaluate("comment.nodeValue")
  end

  test "ruby: Node.nodeType returns a node type constant (9 for document)", :ruby, :dom_1_core do
    assert_equal 1,  Nokogiri::XML::Node::ELEMENT_NODE
    assert_equal 2,  Nokogiri::XML::Node::ATTRIBUTE_NODE
    assert_equal 3,  Nokogiri::XML::Node::TEXT_NODE
    assert_equal 4,  Nokogiri::XML::Node::CDATA_SECTION_NODE
    assert_equal 5,  Nokogiri::XML::Node::ENTITY_REF_NODE
    assert_equal 6,  Nokogiri::XML::Node::ENTITY_NODE
    assert_equal 7,  Nokogiri::XML::Node::PI_NODE
    assert_equal 8,  Nokogiri::XML::Node::COMMENT_NODE
    assert_equal 9,  Nokogiri::XML::Node::DOCUMENT_NODE
    assert_equal 10, Nokogiri::XML::Node::DOCUMENT_TYPE_NODE
    assert_equal 11, Nokogiri::XML::Node::DOCUMENT_FRAG_NODE
    assert_equal 12, Nokogiri::XML::Node::NOTATION_NODE

    assert_equal 1, div.nodeType
    assert_equal 2, div.getAttributeNode('id').nodeType
    assert_equal 3, div.firstChild.nodeType
    assert_equal 8, document.createComment('comment').nodeType
    assert_equal 9, document.nodeType
    assert_equal 11, document.createDocumentFragment.nodeType
  end

  test "js: Node.nodeType returns a node type constant (9 for document)", :js, :dom_1_core do
    assert_equal 1, window.evaluate("div.nodeType")
    assert_equal 2, window.evaluate("div.getAttributeNode('id').nodeType")
    assert_equal 3, window.evaluate("div.firstChild.nodeType")
    assert_equal 8, window.evaluate("document.createComment('comment').nodeType")
    assert_equal 9, window.evaluate("document.nodeType")
    assert_equal 11, window.evaluate("document.createDocumentFragment().nodeType")
  end

  test "ruby: Node.parentNode returns the parent of the specified node in the DOM tree (null for document)", :ruby, :dom_1_core do
    assert_equal 'BODY', div.parentNode.nodeName
  end

  test "js: Node.parentNode returns the parent of the specified node in the DOM tree (null for document)", :js, :dom_1_core do
    assert_equal 'BODY', window.evaluate("div.parentNode.nodeName")
  end

  test "ruby: Node.childNodes returns a collection of child nodes of the given node NodeList", :ruby, :dom_1_core do
    assert body.childNodes.respond_to?(:length)
    assert_equal 2, body.childNodes.length
  end

  test "js: Node.childNodes returns a collection of child nodes of the given node NodeList", :js, :dom_1_core do
    assert_equal 2, window.evaluate("body.childNodes.length")
  end

  test "ruby: Node.firstChild returns the first node in the list of direct children of the document", :ruby, :dom_1_core do
    assert_equal 'DIV', body.firstChild.nodeName
  end

  test "js: Node.firstChild returns the first node in the list of direct children of the document", :js, :dom_1_core do
    assert_equal 'DIV', window.evaluate("body.firstChild.nodeName")
  end

  test "ruby: Node.lastChild returns the last child of a node Node", :ruby, :dom_1_core do
    assert_equal 'P', body.lastChild.nodeName
  end

  test "js: Node.lastChild returns the last child of a node Node", :js, :dom_1_core do
    assert_equal 'P', window.evaluate("body.lastChild.nodeName")
  end

  test "ruby: Node.previousSibling returns the node immediately preceding the specified one in its parent's childNodes list, null if the specified node is the first in that list (null for document)", :ruby, :dom_1_core do
    assert_equal 'DIV', body.lastChild.previousSibling.nodeName
  end

  test "js: Node.previousSibling returns the node immediately preceding the specified one in its parent's childNodes list, null if the specified node is the first in that list (null for document)", :js, :dom_1_core do
    assert_equal 'DIV', window.evaluate("body.lastChild.previousSibling.nodeName")
  end

  test "ruby: Node.nextSibling returns the node immediately following the specified one in its parent's childNodes list, or null if the specified node is the last node in that list (null for documents)", :ruby, :dom_1_core do
    assert_equal 'P', body.firstChild.nextSibling.nodeName
  end

  test "js: Node.nextSibling returns the node immediately following the specified one in its parent's childNodes list, or null if the specified node is the last node in that list (null for documents)", :js, :dom_1_core do
    assert_equal 'P', window.evaluate("body.firstChild.nextSibling.nodeName")
  end

  test "ruby: Node.attributes returns a collection of attributes of the given element", :ruby, :dom_1_core do
    assert_equal 'id',  div.attributes['id'].name
    assert_equal 'foo', div.attributes['id'].value
  end

  test "js: Node.attributes returns a collection of attributes of the given element", :js, :dom_1_core do
    assert_equal 'id',  window.evaluate("div.attributes['id'].name")
    assert_equal 'foo', window.evaluate("div.attributes['id'].value")
  end

  test "ruby: Node.ownerDocument returns the top-level document object for this node (null if already is the document)", :ruby, :dom_1_core do
    assert_equal document.object_id, div.ownerDocument.object_id
  end

  test "js: Node.ownerDocument returns the top-level document object for this node (null if already is the document)", :js, :dom_1_core do
    assert_equal document.object_id, window.evaluate("div.ownerDocument").object_id
  end

  test "ruby: Node.insertBefore inserts the specified node before a reference node as a child of the current node", :ruby, :dom_1_core do
    body.insertBefore(document.createElement('span'), body.lastChild)
    assert_equal %w(DIV SPAN P), body.childNodes.map { |child| child.nodeName }

    body.insertBefore(document.createElement('span'), nil)
    assert_equal %w(DIV SPAN P SPAN), body.childNodes.map { |child| child.nodeName }
  end

  def assert_node_names(code, expected_names)
    # assert_equal expected_names, window.evaluate("nodeNamesOf(#{code})")
    assert_equal expected_names, window.evaluate("body.childNodes").map { |node| node.nodeName }
  end

  test "js: Node.insertBefore inserts the specified node before a reference node as a child of the current node", :js, :dom_1_core do
    window.evaluate("body.insertBefore(document.createElement('span'), body.lastChild)")
    assert_node_names "body.childNodes", %w(DIV SPAN P)
  end

  test "ruby: Node.replaceChild replaces one child node of the specified node with another", :ruby, :dom_1_core do
    body.replaceChild(document.createElement('span'), div)
    assert_equal %w(SPAN P), body.childNodes.map { |child| child.nodeName }
  end

  test "js: Node.replaceChild replaces one child node of the specified node with another", :js, :dom_1_core do
    window.evaluate("body.replaceChild(document.createElement('span'), div)")
    assert_node_names "body.childNodes", %w(SPAN P)
  end

  test "ruby: Node.appendChild adds a node to the end of the list of children of a specified parent node", :ruby, :dom_1_core do
    body.appendChild(document.createElement('span'))
    assert_node_names "body.childNodes", %w(DIV P SPAN)
  end

  test "js: Node.appendChild adds a node to the end of the list of children of a specified parent node", :js, :dom_1_core do
    window.evaluate("body.appendChild(document.createElement('span'))")
    assert_node_names "body.childNodes", %w(DIV P SPAN)
  end

  test "ruby: Node.removeChild removes an existing child node from the DOM", :ruby, :dom_1_core do
    body.removeChild(div)
    assert_equal %w(P), body.childNodes.map { |child| child.nodeName }
  end

  test "js: Node.removeChild removes an existing child node from the DOM", :js, :dom_1_core do
    window.evaluate("body.removeChild(div)")
    assert_node_names "body.childNodes", %w(P)
  end

  test "ruby: Node.removeChild removes a new child node from the DOM", :ruby, :dom_1_core do
    a = document.createElement('a')
      document.body.appendChild(a)
      document.body.removeChild(a)
    assert_equal %w(DIV P), body.childNodes.map { |child| child.nodeName }
  end

  test "js: Node.removeChild removes a new child node from the DOM", :js, :dom_1_core do
    window.evaluate <<-js
      a = document.createElement('a')
      document.body.appendChild(a)
      document.body.removeChild(a)
    js
    assert_equal %w(DIV P), window.evaluate("body.childNodes").map { |node| node.nodeName }
    # assert_equal %w(DIV P), window.evaluate("nodeNamesOf(body.childNodes)").to_a
  end

  test "ruby: Node.hasChildNodes returns a Boolean value indicating whether the current element has child nodes or not", :ruby, :dom_1_core do
    assert body.hasChildNodes
    assert !div.firstChild.hasChildNodes
  end

  test "js: Node.hasChildNodes returns a Boolean value indicating whether the current element has child nodes or not", :js, :dom_1_core do
    assert window.evaluate("body.hasChildNodes()")
    assert window.evaluate("!div.firstChild.hasChildNodes()")
  end

  test "ruby: Node.cloneNode makes a copy of a node or document", :ruby, :dom_1_core do
    assert_equal '<body></body>', body.cloneNode.to_s
    assert_equal 'FOO', body.cloneNode(true).firstChild.textContent
    assert div.object_id != div.cloneNode.object_id
  end

  test "js: Node.cloneNode makes a copy of a node or document", :js, :dom_1_core do
    assert_equal 'FOO', window.evaluate("body.cloneNode(true).firstChild.textContent")
  end

  # DOM-Level-2-Core
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Core-20001113/core.html
  # test "ruby: Node.normalize normalizes the node or document", :ruby, :dom_2_core do
  # end
  #
  # test "ruby: Node.isSupported tests whether the DOM implementation implements a specific feature and that feature is supported by this node or document", :ruby, :dom_2_core do
  # end
  #
  # test "ruby: Node.namespaceURI returns the XML namespace of the current document", :ruby, :dom_2_core do
  # end
  #
  # test "ruby: Node.prefix returns the namespace prefix of the specified node, or null if no prefix is specified", :ruby, :dom_2_core do
  # end
  #
  # test "ruby: Node.localName returns the local part of the qualified name of this node (null for a document)", :ruby, :dom_2_core do
  # end

  test "ruby: Node.hasAttributes indicates whether the node possesses attributes", :ruby, :dom_2_core do
    assert div.hasAttributes
    assert !body.hasAttributes
  end

  test "js: Node.hasAttributes indicates whether the node possesses attributes", :js, :dom_2_core do
    assert window.evaluate("div.hasAttributes()")
    assert !window.evaluate("body.hasAttributes()")
  end

  # http://www.quirksmode.org/dom/tests/basics.html
  test 'ruby: compareDocumentPosition quirksmode test' do
    window.load <<-html
      <p id="test" class="testClass">Test <code>&lt;p&gt;</code> with <code>id="test"</code>
        and <code>class="testClass"</code>. It contains a
      <b id="testB"><code>&lt;b&gt;</code> with id="testB"</b>.</p>
      <p id="test2" class="nonsense testClass"><code>&lt;p&gt;</code> with id="test2" and
        class="nonsense testClass"</p>
    html

    x = window.document.getElementById('test')
    y = window.document.getElementById('test2')
    z = window.document.getElementById('testB')
    assert_equal 4, x.compareDocumentPosition(y)
    assert_equal 20, x.compareDocumentPosition(z)
  end

  # http://plugins.jquery.com/project/compareDocumentPosition
  test 'ruby: compareDocumentPosition jquery plugin test' do
    window.load <<-html
      <div id="div1"><p id="p1">Hello, world</p><p id="p2"></p></div><p id="p3"></p>
    html

    div1 = window.document.getElementById('div1')
    p1   = window.document.getElementById('p1')
    p2   = window.document.getElementById('p2')
    p3   = window.document.getElementById('p3')

    assert_equal 20, div1.compareDocumentPosition(p1)
    assert_equal 10, p1.compareDocumentPosition(div1)
    assert_equal 4,  p1.compareDocumentPosition(p2)
    assert_equal 2,  p3.compareDocumentPosition(p1)
    assert_equal 0,  p1.compareDocumentPosition(p1)
    assert_equal 10, p1.firstChild.compareDocumentPosition(div1)
  end

  test "ruby: Nokogiri <=>" do
    window.load <<-html
      <html>
        <body>
          <div id='a'>
            <div id='aa'><div id='aaa'></div></div>
            <div id='ab'></div>
          </div>
          <div id='b'>
            <div id='ba'><div id='baa'></div></div>
            <div id='bb'></div>
          </div>
        </body>
      </html>
    html

    node = lambda { |id| window.document.getElementById(id) }

    assert node.call('a')   <=> node.call('aa')
    assert node.call('a')   <=> node.call('aaa')
    assert node.call('a')   <=> node.call('ab')
    assert node.call('a')   <=> node.call('b')
    assert node.call('a')   <=> node.call('ba')
    assert node.call('a')   <=> node.call('baa')
    assert node.call('a')   <=> node.call('bb')

    assert node.call('aa')  <=> node.call('aaa')
    assert node.call('aa')  <=> node.call('ab')
    assert node.call('aa')  <=> node.call('b')
    assert node.call('aa')  <=> node.call('ba')
    assert node.call('aa')  <=> node.call('baa')
    assert node.call('aa')  <=> node.call('bb')

    assert node.call('aaa') <=> node.call('ab')
    assert node.call('aaa') <=> node.call('b')
    assert node.call('aaa') <=> node.call('ba')
    assert node.call('aaa') <=> node.call('baa')
    assert node.call('aaa') <=> node.call('bb')

    assert node.call('ab')  <=> node.call('b')
    assert node.call('ab')  <=> node.call('ba')
    assert node.call('ab')  <=> node.call('baa')
    assert node.call('ab')  <=> node.call('bb')

    assert node.call('b')   <=> node.call('ba')
    assert node.call('b')   <=> node.call('baa')
    assert node.call('b')   <=> node.call('bb')

    assert node.call('ba')  <=> node.call('baa')
    assert node.call('ba')  <=> node.call('bb')

    assert node.call('baa') <=> node.call('bb')
  end
end
