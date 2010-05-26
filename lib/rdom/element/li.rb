# http://www.w3.org/TR/html401/struct/lists.html#edef-LI
# <!ELEMENT LI - O (%flow;)*             -- list item -->
# <!ATTLIST LI
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-74680021
# interface HTMLLIElement : HTMLElement {
#            attribute DOMString       type;
#            attribute long            value;
# };
module RDom
  module Element
    module Li
      include Element, Node

      dom_attributes :type, :value
    end
  end
end