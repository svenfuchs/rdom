module RDom
  module Element
    module Option
      def self.extended(element)
        element.defaultSelected = element.selected
      end
      
      attr_accessor :defaultSelected
      properties :defaultSelected, :form
      dom_attributes :text, :index, :disabled, :label, :selected, :value
    end
  end
end