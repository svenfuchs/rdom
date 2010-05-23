# Represents a css rule set in a stylesheet that defines styles (as opposed to 
# rules defined by @import, @media etc.). 
# Consists of a list of selectors and a style declaration.
module RDom
  module Css
    module StyleRule
      # The textual representation of the selector for the rule set. The
      # implementation may have stripped out insignificant whitespace while
      # parsing the selector.
      def selectorText
        selectors.map { |selector| selector.strip }.join(', ')
      end
      
      # The declaration-block of this rule set.
      def style
        @declarations
      end
      
      def type
        Rule::STYLE_RULE
      end
      
      protected
        
        def parse_declarations!(block) # TODO no reasonable way to hook in to css_parser. submit a patch
          @declarations = StyleDeclaration.new(self)

          return unless block

          block.gsub!(/(^[\s]*)|([\s]*$)/, '')
          block.split(/[\;$]+/m).each do |decs|
            if matches = decs.match(/(.[^:]*)\:(.[^;]*)(;|\Z)/i)
              property, value, end_of_declaration = matches.captures
              add_declaration!(property, value)
            end
          end
        end
    end
  end
end