module RDom
  module Node
    include Properties, RDom::Element, RDom::Event::Target
    
    PROPERTIES = [
      :nodeType, :nodeName, :nodeValue, :parentNode, :childNodes, :firstChild, 
      :lastChild, :previousSibling, :nextSibling, :attributes, :hasAttributes, 
      :ownerDocument, :hasChildNodes, :textContent, :name
    ]
    
    def createDocumentFragment
      doc.import LibXML::XML::Node.new('#document_fragment')
    end

    # returns a node type constant (9 for document)
    def nodeType
      node_type
    end
    
    # returns the node's name (#document for document)
    def nodeName
      name
    end

    # returns the node's value (null for document)
    # For the document itself, nodeValue returns null. For text, comment, and
    # CDATA nodes, nodeValue returns the content of the node. For attribute
    # nodes, the value of the attribute is returned.
    # http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-F68D080
    def nodeValue
      case true
      when text?, comment?, cdata?
        content
      when attribute?
        value
      else
        nil
      end
    end
    
    def textContent
      content
    end

    # returns the parent of the specified node in the DOM tree (null for document)
    def parentNode
      parent
    end

    # returns a collection of child nodes of the given node NodeList
    def childNodes
      nodes = children
      nodes.extend(NodeList)
      nodes
    end

    # returns the first node in the list of direct children of the document
    def firstChild
      children.first
    end

    # returns the last child of a node Node
    def lastChild
      children.last
    end

    # returns the node immediately preceding the specified one in its parent's childNodes list, null if the specified node is the first in that list (null for document)
    def previousSibling
      parent.children[parent.children.index(self) - 1] if parent
    end

    # returns the node immediately following the specified one in its parent's childNodes list, or null if the specified node is the last node in that list (null for documents)
    def nextSibling
      parent.children[parent.children.index(self) + 1] if parent
    end

    # returns a collection of attributes of the given element
    def attributes
      super
    end

    # returns the top-level document object for this node (null if already is the document)
    def ownerDocument
      doc
    end

    # inserts the specified node before a reference node as a child of the current node
    def insertBefore(new_child, next_child)
      if next_child
        siblings = [next_child]
        siblings << next_child while next_child = next_child.next
        appendChild(new_child)
        siblings.each { |sibling| appendChild(sibling) }
      else
        appendChild(new_child)
      end
    end

    # replaces one child node of the specified node with another
    def replaceChild(new_child, old_child)
      insertBefore(new_child, old_child.next)
      old_child.remove!
    end

    # adds a node to the end of the list of children of a specified parent node
    def appendChild(child)
      if child.nodeType == XML::Node::DOCUMENT_FRAG_NODE
        child.childNodes.each { |child| appendChild(child) }
      else
        child = doc.import(child) if doc && doc != child.doc # gosh. importing seems to alter the tree, somehow.
        self << child
      end
      child
    end

    # removes a child node from the DOM
    def removeChild(child)
      child.remove!
    end

    # returns a Boolean value indicating whether the current element has child nodes or not
    def hasChildNodes
      !children.empty?
    end

    # makes a copy of a node or document
    def cloneNode(deep)
      copy(deep)
    end

    # indicates whether the node possesses attributes
    def hasAttributes
      attributes?
    end

    protected

      def ancestors
        ancestors, node = [], self
        ancestors << node while node = node.parent
        ancestors
      end
  end
end