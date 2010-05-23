# interface CSSStyleSheet : stylesheets::StyleSheet {
#   readonly attribute CSSRule          ownerRule;
#   readonly attribute CSSRuleList      cssRules;
#   unsigned long      insertRule(in DOMString rule, 
#                                 in unsigned long index)
#                                         raises(DOMException);
#   void               deleteRule(in unsigned long index)
#                                         raises(DOMException);
# };

module RDom
  module Css
    class StyleSheet
      class << self
        def parse(css)
          stylesheet = new
          # css = '.h1 span{color:#111;}'
          # css = '.bar{color:#000;}'
          # p CSSDeclarationParser.new.parse(css)
          # parser = CssParser::Parser.new
          # parser.add_block!(css)
          # parser.each_rule_set { |rule| stylesheet.cssRules << rule }
          stylesheet
        end
      end
      
      attr_reader :rules, :owner
      protected :rules, :owner
      
      def initialize(owner = nil)
        @rules = []
        @owner = owner
      end
      
      # The list of all CSS rules contained within the style sheet. This 
      # includes both rule sets and at-rules.
      def cssRules
        rules
      end

      # If this style sheet comes from an @import rule, the ownerRule
      # attribute will contain the CSSImportRule. In that case, the ownerNode
      # attribute in the StyleSheet interface will be null. If the style sheet
      # comes from an element or a processing instruction, the ownerRule
      # attribute will be null and the ownerNode attribute will contain the
      # Node.
      def ownerRule
        owner
      end
      
      # Used to insert a new rule into the style sheet. The new rule now 
      # becomes part of the cascade.
      # rule  - The parsable text representing the rule. For rule sets this 
      #         contains both the selector and the style declaration. For 
      #         at-rules, this specifies both the at-identifier and the rule 
      #         content.
      # index - The index within the style sheet's rule list of the rule before 
      #         which to insert the specified rule. If the specified index is 
      #         equal to the length of the style sheet's rule collection, the 
      #         rule will be added to the end of the style sheet.
      def insertRule(rule, index)
      end

      # Used to delete a rule from the style sheet.
      def deleteRule(index)
        # DOMException INDEX_SIZE_ERR: Raised if the specified index does not correspond to a rule in the style sheet's rule list.
        # DOMException NO_MODIFICATION_ALLOWED_ERR: Raised if this style sheet is readonly.
      end
    end
  end
end