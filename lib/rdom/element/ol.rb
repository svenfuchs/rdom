# http://www.w3.org/TR/html401/struct/lists.html#edef-OL
# <!ELEMENT OL - - (LI)+                 -- ordered list -->
# <!ATTLIST OL
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-58056027
# interface HTMLOListElement : HTMLElement {
#            attribute boolean         compact;
#            attribute long            start;
#            attribute DOMString       type;
# };
module RDom
  module Element
    module Ol
      include Element, Node

      html_attributes :compact, :start, :type
    end
  end
end