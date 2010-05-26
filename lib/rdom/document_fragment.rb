module RDom
  module DocumentFragment
    properties :nodeType, :nodeName, :nodeValue, :tagName # TODO complete from dom specs
    
    def nodeType
      node_type
    end
    
    def nodeName
      '#document-fragment'
    end
    alias :tagName :nodeName
    
    def nodeValue
    end
  end
end
