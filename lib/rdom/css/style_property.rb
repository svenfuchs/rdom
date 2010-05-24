module RDom
  module Css
    class StyleProperty
      attr_reader :name, :value, :priority
      
      def initialize(name, value, priority)
        @name, @value, @priority = name, value, priority
      end
      
      def ==(other)
        to_s == other.to_s
      end
      
      def to_s
        value + (priority.nil? || priority.empty? ? '' : " #{priority}") 
      end
    end
  end
end