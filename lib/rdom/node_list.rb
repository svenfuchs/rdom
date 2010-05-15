module RDom
  module NodeList
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