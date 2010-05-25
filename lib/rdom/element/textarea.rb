# http://www.w3.org/TR/html401/interact/forms.html#edef-TEXTAREA
# <!ELEMENT TEXTAREA - - (#PCDATA)       -- multi-line text field -->
# <!ATTLIST TEXTAREA
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   name        CDATA          #IMPLIED
#   rows        NUMBER         #REQUIRED
#   cols        NUMBER         #REQUIRED
#   disabled    (disabled)     #IMPLIED  -- unavailable in this context --
#   readonly    (readonly)     #IMPLIED
#   tabindex    NUMBER         #IMPLIED  -- position in tabbing order --
#   accesskey   %Character;    #IMPLIED  -- accessibility key character --
#   onfocus     %Script;       #IMPLIED  -- the element got the focus --
#   onblur      %Script;       #IMPLIED  -- the element lost the focus --
#   onselect    %Script;       #IMPLIED  -- some text was selected --
#   onchange    %Script;       #IMPLIED  -- the element value was changed --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-24874179
# interface HTMLTextAreaElement : HTMLElement {
#   // Modified in DOM Level 2:
#            attribute DOMString       defaultValue;
#   readonly attribute HTMLFormElement form;
#            attribute DOMString       accessKey;
#            attribute long            cols;
#            attribute boolean         disabled;
#            attribute DOMString       name;
#            attribute boolean         readOnly;
#            attribute long            rows;
#            attribute long            tabIndex;
#   readonly attribute DOMString       type;
#            attribute DOMString       value;
#   void               blur();
#   void               focus();
#   void               select();
# };
module RDom
  module Element
    module Textarea
      include Element, Node

      def self.extended(element)
        element.defaultValue = element.value
      end

      html_attributes :accessKey, :cols, :disabled, :name, :readOnly, :rows,
                     :tabIndex, :type, :value, :onfocus, :onblur, :onselect,
                     :onchange

      properties :form, :defaultValue
      attr_accessor :defaultValue

      # TODO blur, focus, select

      def form
        find_parent_by_tag_name('FORM')
      end
    end
  end
end

