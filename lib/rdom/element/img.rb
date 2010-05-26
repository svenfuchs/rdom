# http://www.w3.org/TR/html401/struct/objects.html#edef-IMG
# <!ELEMENT IMG - O EMPTY                -- Embedded image -->
# <!ATTLIST IMG
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   src         %URI;          #REQUIRED -- URI of image to embed --
#   alt         %Text;         #REQUIRED -- short description --
#   longdesc    %URI;          #IMPLIED  -- link to long description
#                                           (complements alt) --
#   name        CDATA          #IMPLIED  -- name of image for scripting --
#   height      %Length;       #IMPLIED  -- override height --
#   width       %Length;       #IMPLIED  -- override width --
#   usemap      %URI;          #IMPLIED  -- use client-side image map --
#   ismap       (ismap)        #IMPLIED  -- use server-side image map --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-17701901
# interface HTMLImageElement : HTMLElement {
#            attribute DOMString       name;
#            attribute DOMString       align;
#            attribute DOMString       alt;
#            attribute DOMString       border;
#   // Modified in DOM Level 2:
#            attribute long            height;
#   // Modified in DOM Level 2:
#            attribute long            hspace;
#            attribute boolean         isMap;
#            attribute DOMString       longDesc;
#            attribute DOMString       src;
#            attribute DOMString       useMap;
#   // Modified in DOM Level 2:
#            attribute long            vspace;
#   // Modified in DOM Level 2:
#            attribute long            width;
# };
module RDom
  module Element
    module Img
      include Element, Node

      dom_attributes :name, :alt, :border, :height, :hspace, :isMap,
                     :longDesc, :src, :useMap, :vspace, :width
    end
  end
end