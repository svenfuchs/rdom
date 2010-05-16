module RDom
  class DocumentFragment
    include Properties
    
    class << self
      def parse(html)
        document = Document.parse("<div id='__fragment__'>#{html}</div>") # urghs ... TODO
        new(document, document.find_first('//div[@id="__fragment__"]').children)
      end
    end
    
    PROPERTIES = [
      :ownerDocument, :nodeType, :nodeName, :nodeValue, :attributes, :parentNode,
      :childNodes, :firstChild, :lastChild
    ]
    
    attr_accessor :doc, :children
    
    def initialize(document, children = [])
      @doc = document
      @children = children
    end
    
    def initialize_copy(copied)
      children = copied.children.clone
    end
    
    def ownerDocument
      doc
    end
    
    def nodeType
      XML::Node::DOCUMENT_FRAG_NODE
    end
    
    def nodeName
      '#document_fragment' # ?
    end
    
    def nodeValue
      # concat the children's nodeValues?
    end
    
    def attributes
      []
    end
    
    def parentNode
    end
    
    def childNodes
      children
    end
    
    def firstChild
      childNodes.first
    end
    
    def lastChild
      childNodes.last
    end
    
    def appendChild(child)
      # child.parent = self
      children << child
      child
    end

    def insertBefore(new_child, next_child)
      if next_child
        siblings = [next_child]
        siblings << next_child while next_child = next_child.next
        children << new_child
        siblings.each { |sibling| children << sibling }
      else
        appendChild(new_child)
      end
    end

    def replaceChild(new_child, old_child)
      insertBefore(new_child, old_child.next)
      old_child.remove!
    end
    
    def cloneNode(deep = false)
      clone = self.clone
      clone.children = children.map { |child| child.cloneNode(deep) } if deep
      clone
    end
    
    def to_s
      children.map { |child| child.to_s }.join
    end
  end
end