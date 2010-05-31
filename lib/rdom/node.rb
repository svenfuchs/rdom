module RDom
  module Node
    include Event::Target

    properties :nodeType, :nodeName, :nodeValue, :parentNode, :childNodes,
               :firstChild, :lastChild, :previousSibling, :nextSibling,
               :attributes, :ownerDocument, :textContent

    def initialize_copy(copied)
      self.ownerDocument = copied.ownerDocument
    end

    def createDocumentFragment
      doc.import LibXML::XML::Node.new('#document_fragment')
    end

    # returns the top-level document object for this node (null if already is the document)
    def ownerDocument
      document
    end

    # returns a node type constant (9 for document)
    def nodeType
      node_type
    end

    # returns the node's name (#document for document)
    def nodeName
      node_name.upcase
    end

    # returns the node's value (null for document)
    # For the document itself, nodeValue returns null. For text, comment, and
    # CDATA nodes, nodeValue returns the content of the node. For attribute
    # nodes, the value of the attribute is returned.
    # http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-F68D080
    def nodeValue
      content if text? || comment? || cdata?
    end

    def textContent
      content
    end

    # returns a collection of attributes of the given element
    def attributes
      attributes = node_attributes
      attributes.extend(RDom::Attributes)
      attributes.node = self
      attributes
    end

    # indicates whether the node possesses attributes
    def hasAttributes
      !node_attributes.empty?
    end

    # returns the parent of the specified node in the DOM tree (null for document)
    def parentNode
      parent
    end

    # returns a collection of child nodes of the given node
    def childNodes
      children
    end

    # returns the first node in the list of direct children of the document
    def firstChild
      childNodes.first
    end

    # returns the last child of a node Node
    def lastChild
      childNodes.last
    end

    # returns the node immediately preceding the specified one in its parent's childNodes list, null if the specified node is the first in that list (null for document)
    def previousSibling
      parent.childNodes[parent.childNodes.index(self) - 1] if parent
    end

    # returns the node immediately following the specified one in its parent's childNodes list, or null if the specified node is the last node in that list (null for documents)
    def nextSibling
      parent.childNodes[parent.childNodes.index(self) + 1] if parent
    end

    # inserts the specified node before a reference node as a child of the current node
    def insertBefore(new_child, next_child)
      if next_child
        siblings = [next_child]
        siblings << next_child while next_child = next_child.next
        appendChild(new_child)
        siblings.each { |sibling| self << sibling }
      else
        appendChild(new_child)
      end
    end

    # replaces one child node of the specified node with another
    def replaceChild(new_child, old_child)
      insertBefore(new_child, old_child.next)
      old_child.remove
    end

    # adds a node to the end of the list of children of a specified parent node
    def appendChild(child)
      self << child
      case child.nodeName
      when 'SCRIPT'
        Element::Script.process(child)
      when 'FRAME', 'IFRAME'
        child.contentWindow = ownerDocument.defaultView
      end
      child
    end

    def <<(child)
      if child.nodeType == XML::Node::DOCUMENT_FRAG_NODE
        child.childNodes.each { |child| appendChild(child) }
      else
        child = doc.import(child) if doc && doc != child.doc # gosh. importing seems to alter the tree, somehow.
        super
      end
    end

    # removes a child node from the DOM
    def removeChild(child)
      child.remove
    end

    # returns a Boolean value indicating whether the current element has child nodes or not
    def hasChildNodes
      !childNodes.empty?
    end

    # makes a copy of a node or document
    def cloneNode(deep = false)
      clone(deep ? 1 : 0)
    end

    def contains(other)
      other.ancestors.include?(self)
    end

    # The specified and the current nodes have no common container node (e.g.
    # they belong to different documents, or one of them is appended to any
    # document, etc.).
    DOCUMENT_POSITION_DISCONNECTED = 1

    # The specified node precedes the current node.
    DOCUMENT_POSITION_PRECEDING    = 2

    # The specified node follows the current node.
    DOCUMENT_POSITION_FOLLOWING    = 4

    # The specified node contains the current node.
    DOCUMENT_POSITION_CONTAINS     = 8

    # The specified node is contained by the current node.
    DOCUMENT_POSITION_CONTAINED_BY = 16

    # The specified and the current nodes have no common container node or the
    # specified and the current nodes are different attributes of the same
    # node. It means that when the DOCUMENT_POSITION_DISCONNECTED flag is set
    # then the DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC flag is also set,
    # furthermore the DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC flag is
    # specified for two different attribute nodes of an element.
    DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 32

    def compareDocumentPosition(other)
      position = 0

      if ownerDocument != other.ownerDocument
        position |= DOCUMENT_POSITION_DISCONNECTED | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC
      elsif attribute? && other.attribute? && parent != other.parent
        position |= DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC
      elsif other.contains(self)
        position |= DOCUMENT_POSITION_CONTAINS
      elsif contains(other)
        position |= DOCUMENT_POSITION_CONTAINED_BY
      end

      if compare(other) == 1
        position |= DOCUMENT_POSITION_PRECEDING
      elsif compare(other) == -1
        position |= DOCUMENT_POSITION_FOLLOWING
      end

      position
    end

    protected

      def document?
        type == Nokogiri::XML::Node::DOCUMENT_NODE
      end

      def attribute?
        type == Nokogiri::XML::Node::ATTRIBUTE_NODE
      end

      def find_parent_by_tag_name(tag_name)
        find_parent { |node| node.tagName == tag_name }
      end

      def find_parent(&block)
        node = self
        return node if block.call(node) while node = node.parent
      end
  end
end