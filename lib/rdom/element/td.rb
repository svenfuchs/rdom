# http://www.w3.org/TR/html401/struct/tables.html#edef-TD
# <!ELEMENT (TH|TD)  - O (%flow;)*       -- table header cell, table data cell-->
# 
# <!-- Scope is simpler than headers attribute for common tables -->
# <!ENTITY % Scope "(row|col|rowgroup|colgroup)">
# 
# <!-- TH is for headers, TD for data, but for cells acting as both use TD -->
# <!ATTLIST (TH|TD)                      -- header or data cell --
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   abbr        %Text;         #IMPLIED  -- abbreviation for header cell --
#   axis        CDATA          #IMPLIED  -- comma-separated list of related headers--
#   headers     IDREFS         #IMPLIED  -- list of id's for header cells --
#   scope       %Scope;        #IMPLIED  -- scope covered by header cells --
#   rowspan     NUMBER         1         -- number of rows spanned by cell --
#   colspan     NUMBER         1         -- number of cols spanned by cell --
#   %cellhalign;                         -- horizontal alignment in cells --
#   %cellvalign;                         -- vertical alignment in cells --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-82915075
# interface HTMLTableCellElement : HTMLElement {
#   readonly attribute long            cellIndex;
#            attribute DOMString       abbr;
#            attribute DOMString       align;
#            attribute DOMString       axis;
#            attribute DOMString       bgColor;
#            attribute DOMString       ch;
#            attribute DOMString       chOff;
#            attribute long            colSpan;
#            attribute DOMString       headers;
#            attribute DOMString       height;
#            attribute boolean         noWrap;
#            attribute long            rowSpan;
#            attribute DOMString       scope;
#            attribute DOMString       vAlign;
#            attribute DOMString       width;
# };
module RDom
  module Element
    module Td
      include Element, Node

      dom_attributes :cellIndex, :abbr, :axis, :bgColor, :colSpan, 
                     :headers, :height, :noWrap, :rowSpan, :scope, :vAlign, 
                     :width
      
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