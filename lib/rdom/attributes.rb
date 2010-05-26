module RDom
  module Attributes
    class << self
      def extended(base)
        class << base
          undef_method :id, :type, :class
        end
      end
    end
    
    properties :length
    
    attr_accessor :node
    
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

    # returns the indexth item in the map. If index is greater than or equal to the number of nodes in the map, this returns null
    def item(index)
      values.each_with_index { |item, ix| return item if index == ix } && nil
    end

    def method_missing(name, *args)
      key?(name) ? self[name] : super
    end
  end
end