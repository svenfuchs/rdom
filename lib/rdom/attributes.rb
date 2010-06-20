module RDom
  class Attributes
    properties :length
    
    attr_accessor :node, :attributes
    
    undef_method :id, :type, :class
    
    def initialize(node, attributes)
      @node = node
      @attributes = attributes
    end
    
    def [](name)
      node.getAttributeNode(name)
    end

    def []=(name, value)
      node.setAttribute(name, value)
    end

    # retrieves a node specified by name
    def getNamedItem(name)
      node.getAttributeNode(name)
    end

    # adds a node using its nodeName attribute
    def setNamedItem(item)
      node.setAttributeNode(item)
    end

    # removes a node specified by name
    def removeNamedItem(name)
      getNamedItem(name).remove
    end

    def length
      attributes.length
    end

    # returns the indexth item in the map. If index is greater than or equal to the number of nodes in the map, this returns null
    def item(index)
      values.each_with_index { |item, ix| return item if index == ix } && nil
    end
    
    def respond_to?(name)
      attributes.key?(name) || attributes.respond_to?(name) || super
    end
    
    def method_missing(name, *args)
      return attributes[name] if attributes.key?(name)
      return attributes.send(name, *args) if attributes.respond_to?(name)
      super
    end
    
    # hmm, therubyracer expects methods to be actually defined
    def method(name)
      define_attribute_methods(name) unless ruby_class.method_defined?(name)
      super
    end
    
    def attribute_methods
      @attribute_methods ||= Module.new.tap { |m| self.extend(m) }
    end
    
    def define_attribute_methods(name)
      attribute_methods.module_eval <<-rb
        def #{name}; attributes['#{name}']; end
        def #{name}=(value); attributes['#{name}'] = value; end
      rb
    end
  end
end