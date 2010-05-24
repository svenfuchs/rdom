# http://www.w3.org/TR/html401/struct/tables.html#edef-COLGROUP
# <!ELEMENT COLGROUP - O (COL)*          -- table column group -->
# <!ATTLIST COLGROUP
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   span        NUMBER         1         -- default number of columns in group --
#   width       %MultiLength;  #IMPLIED  -- default width for enclosed COLs --
#   %cellhalign;                         -- horizontal alignment in cells --
#   %cellvalign;                         -- vertical alignment in cells --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-84150186
# interface HTMLTableColElement : HTMLElement {
#            attribute DOMString       align;
#            attribute DOMString       ch;
#            attribute DOMString       chOff;
#            attribute long            span;
#            attribute DOMString       vAlign;
#            attribute DOMString       width;
# };
module RDom
  module Element
    module Colgroup
      include Element, Node

      html_attributes :axis, :span, :vAlign, :width
      
      properties :ch, :chOff

      def ch
        getAttribute('char').to_s
      end

      def ch=(value)
        setAttribute('char', value.to_s)
      end

      def chOff
        getAttribute('charOff').to_s
      end

      def chOff=(value)
        setAttribute('charOff', value.to_s)
      end
    end
  end
end