# http://www.w3.org/TR/html401/interact/forms.html#edef-FIELDSET
# <!ELEMENT FIELDSET - - (#PCDATA,LEGEND,(%flow;)*) -- form control group -->
# <!ATTLIST FIELDSET
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-7365882
# interface HTMLFieldSetElement : HTMLElement {
#   readonly attribute HTMLFormElement form;
# };
module RDom
  module Element
    module Fieldset
      include Element, Node

      dom_attributes :form
    end
  end
end