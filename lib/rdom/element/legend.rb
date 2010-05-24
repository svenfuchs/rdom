# http://www.w3.org/TR/html401/interact/forms.html#edef-LEGEND
# <!ELEMENT LEGEND - - (%inline;)*       -- fieldset legend -->
# 
# <!ATTLIST LEGEND
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   accesskey   %Character;    #IMPLIED  -- accessibility key character --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-21482039
# interface HTMLLegendElement : HTMLElement {
#   readonly attribute HTMLFormElement form;
#            attribute DOMString       accessKey;
#            attribute DOMString       align;
# };
module RDom
  module Element
    module Legend
      include Element, Node

      html_attributes :form, :accessKey, :align
    end
  end
end