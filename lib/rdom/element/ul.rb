# http://www.w3.org/TR/html401/struct/lists.html#edef-UL
# <!ELEMENT UL - - (LI)+                 -- unordered list -->
# <!ATTLIST UL
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-86834457
# interface HTMLUListElement : HTMLElement {
#            attribute boolean         compact;
#            attribute DOMString       type;
# };
module RDom
  module Element
    module Ul
      include Element, Node

      html_attributes :compact, :type
    end
  end
end