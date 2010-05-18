require File.expand_path('../../test_helper', __FILE__)

class NodeTest < Test::Unit::TestCase
  attr_reader :window, :document, :body, :div

  def setup
    @window = RDom::Window.new('<html><body><div id="foo">FOO</div><p class="bar">BAR</p></body></html>')
    @document = window.document
    @body = document.find_first('//body')
    @div = document.find_first('//div')

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

  test "ruby: identical nodes obtained from various methods are the same objects", :ruby, :implementation do
    assert_equal document.object_id, body.ownerDocument.object_id
    assert_equal document.object_id, div.parentNode.ownerDocument.object_id

    assert_equal body.object_id, div.parentNode.object_id
    assert_equal body.object_id, div.parentNode.lastChild.parentNode.object_id
  end

  # DOM-Level-1-Core
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html

  test "ruby: Node.nodeName returns the node's name (#document for document)", :ruby, :dom_1_core do
    assert_equal 'DIV', div.nodeName
  end

  test "js: Node.nodeName returns the node's name (#document for document)", :js, :dom_1_core do
    assert_equal 'DIV', window.evaluate("div.nodeName")
  end

  test "ruby: Node.nodeValue returns the node's value (null for document)", :ruby, :dom_1_core do
    assert_nil document.nodeValue
    assert_nil div.nodeValue
    # TODO: attributes, comments, cdata
  end

  test "js: Node.nodeValue returns the node's value (null for document)", :js, :dom_1_core do
    assert_nil window.evaluate("document.nodeValue")
    assert_nil window.evaluate("div.nodeValue")
    # TODO: attributes, comments, cdata
  end

  test "ruby: Node.nodeType returns a node type constant (9 for document)", :ruby, :dom_1_core do
    assert_equal 1,  LibXML::XML::Node::ELEMENT_NODE
    assert_equal 2,  LibXML::XML::Node::ATTRIBUTE_NODE
    assert_equal 3,  LibXML::XML::Node::TEXT_NODE
    assert_equal 4,  LibXML::XML::Node::CDATA_SECTION_NODE
    assert_equal 5,  LibXML::XML::Node::ENTITY_REF_NODE
    assert_equal 6,  LibXML::XML::Node::ENTITY_NODE
    assert_equal 7,  LibXML::XML::Node::PI_NODE
    assert_equal 8,  LibXML::XML::Node::COMMENT_NODE
    assert_equal 9,  LibXML::XML::Node::DOCUMENT_NODE
    assert_equal 10, LibXML::XML::Node::DOCUMENT_TYPE_NODE
    assert_equal 11, LibXML::XML::Node::DOCUMENT_FRAG_NODE
    assert_equal 12, LibXML::XML::Node::NOTATION_NODE

    assert_equal 9, document.nodeType
    assert_equal 1, div.nodeType
    # TODO: attributes, comments, cdata, ...
  end

  test "js: Node.nodeType returns a node type constant (9 for document)", :js, :dom_1_core do
    assert_equal 9, window.evaluate("document.nodeType")
    assert_equal 1, window.evaluate("div.nodeType")
    # TODO: attributes, comments, cdata, ...
  end

  test "ruby: Node.parentNode returns the parent of the specified node in the DOM tree (null for document)", :ruby, :dom_1_core do
    assert_equal 'BODY', div.parentNode.nodeName
  end

  test "js: Node.parentNode returns the parent of the specified node in the DOM tree (null for document)", :js, :dom_1_core do
    assert_equal 'BODY', window.evaluate("div.parentNode.nodeName")
  end

  test "ruby: Node.childNodes returns a collection of child nodes of the given node NodeList", :ruby, :dom_1_core do
    assert_equal Array, body.childNodes.class
    assert_equal 2, body.childNodes.size
  end

  test "js: Node.childNodes returns a collection of child nodes of the given node NodeList", :js, :dom_1_core do
    assert_equal Array, window.evaluate("body.childNodes").class
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
    assert_equal 'id',  div.attributes.to_a[0].name
    assert_equal 'foo', div.attributes.to_a[0].value
  end

  test "js: Node.attributes returns a collection of attributes of the given element", :js, :dom_1_core do
    assert_equal 'id',  window.evaluate("div.attributes.toArray()[0].name")
    assert_equal 'foo', window.evaluate("div.attributes.toArray()[0].value")
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

  test "js: Node.insertBefore inserts the specified node before a reference node as a child of the current node", :js, :dom_1_core do
    window.evaluate("body.insertBefore(document.createElement('span'), body.lastChild)")
    assert_equal %w(DIV SPAN P), window.evaluate("nodeNamesOf(body.childNodes)").to_a

    window.evaluate("body.insertBefore(document.createElement('span'), null)")
    assert_equal %w(DIV SPAN P SPAN), window.evaluate("nodeNamesOf(body.childNodes)").to_a
  end

  test "ruby: Node.replaceChild replaces one child node of the specified node with another", :ruby, :dom_1_core do
    body.replaceChild(document.createElement('span'), div)
    assert_equal %w(SPAN P), body.childNodes.map { |child| child.nodeName }
  end

  test "js: Node.replaceChild replaces one child node of the specified node with another", :js, :dom_1_core do
    window.evaluate("body.replaceChild(document.createElement('span'), div)")
    assert_equal %w(SPAN P), window.evaluate("nodeNamesOf(body.childNodes)").to_a
  end

  test "ruby: Node.appendChild adds a node to the end of the list of children of a specified parent node", :ruby, :dom_1_core do
    body.appendChild(document.createElement('span'))
    assert_equal %w(DIV P SPAN), body.childNodes.map { |child| child.nodeName }
  end

  test "js: Node.appendChild adds a node to the end of the list of children of a specified parent node", :js, :dom_1_core do
    window.evaluate("body.appendChild(document.createElement('span'))")
    assert_equal %w(DIV P SPAN), window.evaluate("nodeNamesOf(body.childNodes)").to_a
  end

  test "ruby: Node.removeChild removes an existing child node from the DOM", :ruby, :dom_1_core do
    body.removeChild(div)
    assert_equal %w(P), body.childNodes.map { |child| child.nodeName }
  end

  test "js: Node.removeChild removes an existing child node from the DOM", :js, :dom_1_core do
    window.evaluate("body.removeChild(div)")
    assert_equal %w(P), window.evaluate("nodeNamesOf(body.childNodes)").to_a
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
    assert_equal %w(DIV P), window.evaluate("nodeNamesOf(body.childNodes)").to_a
  end

  test "ruby: Node.hasChildNodes returns a Boolean value indicating whether the current element has child nodes or not", :ruby, :dom_1_core do
    assert body.hasChildNodes
    # TODO test an attribute
  end

  test "js: Node.hasChildNodes returns a Boolean value indicating whether the current element has child nodes or not", :js, :dom_1_core do
    assert window.evaluate("body.hasChildNodes()")
    # TODO test an attribute
  end

  test "ruby: Node.cloneNode makes a copy of a node or document", :ruby, :dom_1_core do
    assert div.object_id != div.clone.object_id
  end

  test "js: Node.cloneNode makes a copy of a node or document", :js, :dom_1_core do
    # TODO
    # assert div.object_id != div.clone.object_id
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
end


# "Node.compareDocumentPosition compares the position of the current node against another node in any other document"
# "Node.getFeature"
# "Node.getUserData returns any data previously set on the node via setUserData() by key"
# "Node.isDefaultNamespace returns true if the namespace is the default namespace on the given node"
# "Node.isEqualNode indicates whether the node is equal to the given node"
# "Node.isSameNode indicates whether the node is the same as the given node"
# "Node.lookupNamespaceURI returns the namespaceURI associated with a given prefix on the given node object"
# "Node.lookupPrefix returns the prefix for a given namespaceURI on the given node if present"
# "Node.setUserData attaches arbitrary data to a node, along with a user-defined key and an optional handler to be triggered upon events such as cloning of the node upon which the data was attached"
# "Node.baseURI baseURI gets the base URI for the document", :dom_3
# "Node.textContent returns null (returns other values for other nodes)", :dom_3
