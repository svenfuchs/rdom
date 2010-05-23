module RDom
  module Css
    module Element
      def style
        Css::StyleDeclaration.new(self, getAttribute('style'))
      end

      def style=(value)
        raise "read-only?"
      end
    end
  end
end