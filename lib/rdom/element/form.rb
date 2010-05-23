module RDom
  module Element
    module Form
      # TODO :method somehow breaks jquery tests, maybe in johnson?
      dom_attributes :name, :acceptCharset, :action, :enctype, :target
      
      properties :elements, :length

      def elements
        find('.//input|.//textarea|.//select|.//button').to_a
      end
      
      def length
        elements.size
      end
    end
  end
end