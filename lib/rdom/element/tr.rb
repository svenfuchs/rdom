# http://www.w3.org/TR/html401/struct/tables.html#edef-TR
# <!ELEMENT TR       - O (TH|TD)+        -- table row -->
# <!ATTLIST TR                           -- table row --
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   %cellhalign;                         -- horizontal alignment in cells --
#   %cellvalign;                         -- vertical alignment in cells --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-6986576
# interface HTMLTableRowElement : HTMLElement {
#   // Modified in DOM Level 2:
#   readonly attribute long            rowIndex;
#   // Modified in DOM Level 2:
#   readonly attribute long            sectionRowIndex;
#   // Modified in DOM Level 2:
#   readonly attribute HTMLCollection  cells;
#            attribute DOMString       align;
#            attribute DOMString       bgColor;
#            attribute DOMString       ch;
#            attribute DOMString       chOff;
#            attribute DOMString       vAlign;
#   // Modified in DOM Level 2:
#   HTMLElement        insertCell(in long index)
#                                         raises(DOMException);
#   // Modified in DOM Level 2:
#   void               deleteCell(in long index)
#                                         raises(DOMException);
# };
module RDom
  module Element
    module Tr
      include Element, Node

      html_attributes :bgColor, :vAlign

      properties :rowIndex, :sectionRowIndex, :cells, :ch, :chOff

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

      def cells
        tag_names = %w(th td)
        tag_names.map { |tag_name| getElementsByTagName(tag_name) }.flatten
      end

      # TODO rowIndes, sectionRowIndex, insertCell, deleteCell
    end
  end
end