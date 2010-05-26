# http://www.w3.org/TR/html401/struct/tables.html#edef-TBODY
# <!ELEMENT TBODY    - O (TR)+           -- table header -->
# <!ATTLIST (THEAD|TBODY|TFOOT)          -- table section --
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   %cellhalign;                         -- horizontal alignment in cells --
#   %cellvalign;                         -- vertical alignment in cells --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-67417573
# interface HTMLTableSectionElement : HTMLElement {
#            attribute DOMString       align;
#            attribute DOMString       ch;
#            attribute DOMString       chOff;
#            attribute DOMString       vAlign;
#   readonly attribute HTMLCollection  rows;
#   // Modified in DOM Level 2:
#   HTMLElement        insertRow(in long index)
#                                         raises(DOMException);
#   // Modified in DOM Level 2:
#   void               deleteRow(in long index)
#                                         raises(DOMException);
# };
module RDom
  module Element
    module Tbody
      include Element, Node

      html_attributes :vAlign
      
      properties :ch, :chOff, :rows

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
      
      def rows
        getElementsByTagName('tr')
      end
    end
  end
end