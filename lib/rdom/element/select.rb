module RDom
  module Element
    module Select
      dom_attributes :type, :selectedIndex, :value, :length, :form, :options,
                 :disabled, :multiple, :name, :size, :tabIndex

      def selectedIndex
        if options.size == 1
          options.first.setAttribute('selected', 'selected')
          0
        else
          options.each_with_index do |option, ix| 
            return ix if option.getAttribute('selected')
          end && -1
        end
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