# http://www.w3.org/TR/html401/struct/tables.html#edef-COL
# <!ELEMENT COL      - O EMPTY           -- table column -->
# <!ATTLIST COL                          -- column groups and properties --
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   span        NUMBER         1         -- COL attributes affect N columns --
#   width       %MultiLength;  #IMPLIED  -- column width specification --
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
    module Col
      include Element, Node

      dom_attributes :axis, :span, :vAlign, :width
      
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