module RDom
  module Element
    module Input
      def self.extended(element)
        element.defaultValue = element.value
        element.defaultChecked = element.checked if %(radio checkbox).include?(element.type)
      end
      
      attr_accessor :defaultValue, :defaultChecked
      properties :defaultValue, :defaultChecked, :form
      dom_attributes :accept, :accessKey, :align, :alt, :checked, :disabled, 
                     :maxLength, :name, :readOnly, :size, :src, :tabIndex, 
                     :type, :useMap, :value
    end
  end
end