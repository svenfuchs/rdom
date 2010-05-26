# http://www.w3.org/TR/html401/interact/forms.html#edef-LABEL
# <!ELEMENT LABEL - - (%inline;)* -(LABEL) -- form field label text -->
# <!ATTLIST LABEL
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   for         IDREF          #IMPLIED  -- matches field ID value --
#   accesskey   %Character;    #IMPLIED  -- accessibility key character --
#   onfocus     %Script;       #IMPLIED  -- the element got the focus --
#   onblur      %Script;       #IMPLIED  -- the element lost the focus --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-13691394
# interface HTMLLabelElement : HTMLElement {
#   readonly attribute HTMLFormElement form;
#            attribute DOMString       accessKey;
#            attribute DOMString       htmlFor;
# };
module RDom
  module Element
    module Label
      include Element, Node

      dom_attributes :form, :accessKey
      properties :htmlFor

      # # http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-213157251
      # The for attribute of the LABEL and SCRIPT elements collides with loop 
      # construct naming conventions and is renamed htmlFor.
      def htmlFor
        getAttribute('for').to_s
      end

      def htmlFor=(value)
        setAttribute('for', value.to_s)
      end
    end
  end
end