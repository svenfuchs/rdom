module RDom
  class Attr
    include Decoration, Properties
    
    PROPERTIES = [
      :nodeType, :document, :name, :value
    ]
    attr_accessor *PROPERTIES
    
    def initialize(document, name)
      @name = name
    end
    
    def nodeType
      XML::Node::ATTRIBUTE_NODE
    end
  end
end