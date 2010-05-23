# interface CSSRule {
#   // Types
#   const unsigned short STYLE_RULE = 1;
#   const unsigned short IMPORT_RULE = 3;
#   const unsigned short MEDIA_RULE = 4;
#   const unsigned short FONT_FACE_RULE = 5;
#   const unsigned short PAGE_RULE = 6;
#   const unsigned short NAMESPACE_RULE = 10;
#   readonly attribute unsigned short type;
# 
#   // Parsing and serialization
#            attribute DOMString cssText;
#
#   // Context
#   readonly attribute CSSRule parentRule;
#   readonly attribute CSSStyleSheet parentStyleSheet;
# };

module RDom
  module Css
    module Rule
      STYLE_RULE     = 1
      IMPORT_RULE    = 3
      MEDIA_RULE     = 4
      FONT_FACE_RULE = 5
      PAGE_RULE      = 6
      NAMESPACE_RULE = 10
      
      def cssText
      end
      
      def parentRule
      end
      
      def parentStyleSheet
      end
    end
  end
end