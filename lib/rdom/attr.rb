module RDom
  module Attr
    properties :name, :value, :nodeType, :nodeValue, :specified, :ownerElement

    # TODO gotta fix this: we need to define :name and :value to keep Properties from defining accessors
    def name
      super
    end

    def value
      super
    end

    def value=(value)
      self.specified = false
      super(value.to_s)
    end
    
    def nodeType
      LibXML::XML::Node::ATTRIBUTE_NODE
    end

    def nodeValue
      value
    end

    def specified
      defined?(@specified) ? @specified : @specified = true
    end
    attr_writer :specified

    def ownerElement
      parent
    end

    def parentNode
      nil
    end

    def previousSibling
      nil
    end

    def nextSibling
      nil
    end
  end
end