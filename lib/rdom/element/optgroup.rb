# http://www.w3.org/TR/html401/interact/forms.html#edef-OPTGROUP
# <!ELEMENT OPTGROUP - - (OPTION)+ -- option group -->
# <!ATTLIST OPTGROUP
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   disabled    (disabled)     #IMPLIED  -- unavailable in this context --
#   label       %Text;         #REQUIRED -- for use in hierarchical menus --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-38450247
# interface HTMLOptGroupElement : HTMLElement {
#            attribute boolean         disabled;
#            attribute DOMString       label;
# };
module RDom
  module Element
    module Optgroup
      include Element, Node

      dom_attributes :disabled, :label
    end
  end
end