module RDom
  module Attributes
    include Decoration

    properties :length

    def [](name)
      getNamedItem(name)
    end

    def key?(name)
      !!getNamedItem(name)
    end

    # retrieves a node specified by name
    def getNamedItem(name)
      item = get_attribute(name)
      item = Attribute.new(node, 'style', node.style) if item && name == 'style'
      item
    end

    # adds a node using its nodeName attribute
    def setNamedItem(item)
      node.setAttributeNode(item)
    end

    # removes a node specified by name
    def removeNamedItem(name)
      getNamedItem(name).remove!
    end

    # returns the indexth item in the map. If index is greater than or equal to the number of nodes in the map, this returns null
    def item(index)
      each_with_index { |item, ix| return item if index == ix } && nil
    end

    # length returns the number of nodes in the list
    def length
      super
    end

    def method_missing(name, *args)
      self.getNamedItem(name) || super
    end
  end
end