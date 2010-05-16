module RDom
  module Element
    module Select
      PROPERTIES = [
        :type, :selectedIndex, :value, :length, :form, :options, :disabled, :multiple, :name, :size, :tabIndex
      ]
      
      def selectedIndex
        options.each_with_index { |option, ix| return ix unless option['selected'].empty? } && -1
      end
      
      # def selectedIndex=(index)
      #   option = options.index(index)
      #   options['selected'] = 'selected' if option
      # end
      
      def options
        find('.//option').to_a
      end
    end
  end
end