module RDom
  module Css
    class StyleProperty
      attr_reader :name, :value, :priority
      
      def initialize(name, value, priority)
        @name, @value, @priority = name, value, priority
      end
    end
  end
end