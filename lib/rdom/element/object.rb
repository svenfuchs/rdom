# http://www.w3.org/TR/html401/struct/objects.html#edef-OBJECT
# <!ELEMENT OBJECT - - (PARAM | %flow;)*
#  -- generic embedded object -->
# <!ATTLIST OBJECT
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   declare     (declare)      #IMPLIED  -- declare but don't instantiate flag --
#   classid     %URI;          #IMPLIED  -- identifies an implementation --
#   codebase    %URI;          #IMPLIED  -- base URI for classid, data, archive--
#   data        %URI;          #IMPLIED  -- reference to object's data --
#   type        %ContentType;  #IMPLIED  -- content type for data --
#   codetype    %ContentType;  #IMPLIED  -- content type for code --
#   archive     CDATA          #IMPLIED  -- space-separated list of URIs --
#   standby     %Text;         #IMPLIED  -- message to show while loading --
#   height      %Length;       #IMPLIED  -- override height --
#   width       %Length;       #IMPLIED  -- override width --
#   usemap      %URI;          #IMPLIED  -- use client-side image map --
#   name        CDATA          #IMPLIED  -- submit as part of form --
#   tabindex    NUMBER         #IMPLIED  -- position in tabbing order --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-9893177
# interface HTMLObjectElement : HTMLElement {
#   readonly attribute HTMLFormElement form;
#            attribute DOMString       code;
#            attribute DOMString       align;
#            attribute DOMString       archive;
#            attribute DOMString       border;
#            attribute DOMString       codeBase;
#            attribute DOMString       codeType;
#            attribute DOMString       data;
#            attribute boolean         declare;
#            attribute DOMString       height;
#            attribute long            hspace;
#            attribute DOMString       name;
#            attribute DOMString       standby;
#            attribute long            tabIndex;
#            attribute DOMString       type;
#            attribute DOMString       useMap;
#            attribute long            vspace;
#            attribute DOMString       width;
#   // Introduced in DOM Level 2:
#   readonly attribute Document        contentDocument;
# };
module RDom
  module Element
    module Object
      include Element, Node

      html_attributes :archive, :border, :classid, :code, :codeBase, :codeType,
                     :data, :declare, :height, :hspace, :name, :standby, :tabIndex,
                     :type, :useMap, :vspace, :width

      properties :form, :contentDocument

      def form
        find_parent { |node| node.tagName == 'FORM' }
      end
    end
  end
end