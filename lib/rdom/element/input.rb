# <!ENTITY % InputType
#   "(TEXT | PASSWORD | CHECKBOX |
#     RADIO | SUBMIT | RESET |
#     FILE | HIDDEN | IMAGE | BUTTON)"
#    >
#
# <!-- attribute name required for all but submit and reset -->
# <!ELEMENT INPUT - O EMPTY              -- form control -->
# <!ATTLIST INPUT
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   type        %InputType;    TEXT      -- what kind of widget is needed --
#   name        CDATA          #IMPLIED  -- submit as part of form --
#   value       CDATA          #IMPLIED  -- Specify for radio buttons and checkboxes --
#   checked     (checked)      #IMPLIED  -- for radio buttons and check boxes --
#   disabled    (disabled)     #IMPLIED  -- unavailable in this context --
#   readonly    (readonly)     #IMPLIED  -- for text and passwd --
#   size        CDATA          #IMPLIED  -- specific to each type of field --
#   maxlength   NUMBER         #IMPLIED  -- max chars for text fields --
#   src         %URI;          #IMPLIED  -- for fields with images --
#   alt         CDATA          #IMPLIED  -- short description --
#   usemap      %URI;          #IMPLIED  -- use client-side image map --
#   ismap       (ismap)        #IMPLIED  -- use server-side image map --
#   tabindex    NUMBER         #IMPLIED  -- position in tabbing order --
#   accesskey   %Character;    #IMPLIED  -- accessibility key character --
#   onfocus     %Script;       #IMPLIED  -- the element got the focus --
#   onblur      %Script;       #IMPLIED  -- the element lost the focus --
#   onselect    %Script;       #IMPLIED  -- some text was selected --
#   onchange    %Script;       #IMPLIED  -- the element value was changed --
#   accept      %ContentTypes; #IMPLIED  -- list of MIME types for file upload --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-6043025
# interface HTMLInputElement : HTMLElement {
#            attribute DOMString       defaultValue;
#            attribute boolean         defaultChecked;
#   readonly attribute HTMLFormElement form;
#            attribute DOMString       accept;
#            attribute DOMString       accessKey;
#            attribute DOMString       align;
#            attribute DOMString       alt;
#            attribute boolean         checked;
#            attribute boolean         disabled;
#            attribute long            maxLength;
#            attribute DOMString       name;
#            attribute boolean         readOnly;
#   // Modified in DOM Level 2:
#            attribute unsigned long   size;
#            attribute DOMString       src;
#            attribute long            tabIndex;
#   // Modified in DOM Level 2:
#            attribute DOMString       type;
#            attribute DOMString       useMap;
#            attribute DOMString       value;
#   void               blur();
#   void               focus();
#   void               select();
#   void               click();
# };
module RDom
  module Element
    module Input
      include Element, Node

      def self.extended(element)
        element.defaultValue = element.value
        element.defaultChecked = element.checked if element.type && %(radio checkbox).include?(element.type)
      end

      html_attributes :accept, :accessKey, :alt, :checked, :disabled,
                     :isMap, :maxLength, :name, :readOnly, :size, :src,
                     :tabIndex, :type, :useMap, :value, :onfocus, :onblur,
                     :onselect, :onchange

      properties :defaultValue, :defaultChecked, :form
      attr_accessor :defaultValue, :defaultChecked

      # TODO blur, focus, select, click

      def form
        find_parent_by_tag_name('FORM')
      end
    end
  end
end