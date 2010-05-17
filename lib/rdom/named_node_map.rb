module RDom
  module NamedNodeMap
    include Decoration

    properties :length
    
    def [](name)
      getNamedItem(name).value
    end
    
    def key?(name)
      !!getNamedItem(name)
    end
    
    # retrieves a node specified by name
    def getNamedItem(name)
      detect { |item| item.name == name }
    end
    
    # adds a node using its nodeName attribute
    def setNamedItem(item)
      raise "not implemented" unless item.is_a?(Attr)
      node.setAttributeNode(item)
    end
    
    # removes a node specified by name. If the removed node is an Attr with a default value it is immediately replaced
    def removeNamedItem(name)
      # TODO default values!
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
  end
end