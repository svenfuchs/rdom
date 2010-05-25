# http://www.w3.org/TR/html401/interact/forms.html#edef-BUTTON
# <!ELEMENT BUTTON - -
#      (%flow;)* -(A|%formctrl;|FORM|FIELDSET)
#      -- push button -->
# <!ATTLIST BUTTON
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   name        CDATA          #IMPLIED
#   value       CDATA          #IMPLIED  -- sent to server when submitted --
#   type        (button|submit|reset) submit -- for use as form button --
#   disabled    (disabled)     #IMPLIED  -- unavailable in this context --
#   tabindex    NUMBER         #IMPLIED  -- position in tabbing order --
#   accesskey   %Character;    #IMPLIED  -- accessibility key character --
#   onfocus     %Script;       #IMPLIED  -- the element got the focus --
#   onblur      %Script;       #IMPLIED  -- the element lost the focus --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-34812697
# interface HTMLButtonElement : HTMLElement {
#   readonly attribute HTMLFormElement form;
#            attribute DOMString       accessKey;
#            attribute boolean         disabled;
#            attribute DOMString       name;
#            attribute long            tabIndex;
#   readonly attribute DOMString       type;
#            attribute DOMString       value;
# };
module RDom
  module Element
    module Button
      include Element, Node

      html_attributes :accessKey, :disabled, :name, :tabIndex, :type, :value

      properties :form

      def form
        find_parent { |node| node.tagName == 'FORM' }
      end
    end
  end
end