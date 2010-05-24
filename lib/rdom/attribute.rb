module RDom
  class Attribute
    include Decoration
    
    properties :nodeType, :document, :name, :value

    attr_accessor *property_names
    
    def initialize(document, name, value = nil)
      @name  = name
      @value = value
    end
    
    def nodeType
      XML::Node::ATTRIBUTE_NODE
    end
  end
end