# http://www.w3.org/TR/html401/struct/tables.html#edef-TABLE
# <!ELEMENT TABLE - -
#      (CAPTION?, (COL*|COLGROUP*), THEAD?, TFOOT?, TBODY+)>
# <!ATTLIST TABLE                        -- table element --
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   summary     %Text;         #IMPLIED  -- purpose/structure for speech output--
#   width       %Length;       #IMPLIED  -- table width --
#   border      %Pixels;       #IMPLIED  -- controls frame width around table --
#   frame       %TFrame;       #IMPLIED  -- which parts of frame to render --
#   rules       %TRules;       #IMPLIED  -- rulings between rows and cols --
#   cellspacing %Length;       #IMPLIED  -- spacing between cells --
#   cellpadding %Length;       #IMPLIED  -- spacing within cells --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-64060425
# interface HTMLTableElement : HTMLElement {
#   // Modified in DOM Level 2:
#            attribute HTMLTableCaptionElement caption;
#                                         // raises(DOMException) on setting
#
#   // Modified in DOM Level 2:
#            attribute HTMLTableSectionElement tHead;
#                                         // raises(DOMException) on setting
#
#   // Modified in DOM Level 2:
#            attribute HTMLTableSectionElement tFoot;
#                                         // raises(DOMException) on setting
#
#   readonly attribute HTMLCollection  rows;
#   readonly attribute HTMLCollection  tBodies;
#            attribute DOMString       align;
#            attribute DOMString       bgColor;
#            attribute DOMString       border;
#            attribute DOMString       cellPadding;
#            attribute DOMString       cellSpacing;
#            attribute DOMString       frame;
#            attribute DOMString       rules;
#            attribute DOMString       summary;
#            attribute DOMString       width;
#   HTMLElement        createTHead();
#   void               deleteTHead();
#   HTMLElement        createTFoot();
#   void               deleteTFoot();
#   HTMLElement        createCaption();
#   void               deleteCaption();
#   // Modified in DOM Level 2:
#   HTMLElement        insertRow(in long index)
#                                         raises(DOMException);
#   // Modified in DOM Level 2:
#   void               deleteRow(in long index)
#                                         raises(DOMException);
# };
module RDom
  module Element
    module Table
      include Element, Node

      html_attributes :bgColor, :border, :cellPadding, :cellSpacing,
                     :frame, :rules, :summary, :width

      properties :caption, :tHead, :tFoot, :rows, :tBodies

      # TODO insertRow, deleteRow, createCaption, deleteCaption, createTHead, ...
    end
  end
end

