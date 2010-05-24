# http://www.w3.org/TR/html401/struct/objects.html#edef-AREA
# <!ELEMENT AREA - O EMPTY               -- client-side image map area -->
# <!ATTLIST AREA
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   shape       %Shape;        rect      -- controls interpretation of coords --
#   coords      %Coords;       #IMPLIED  -- comma-separated list of lengths --
#   href        %URI;          #IMPLIED  -- URI for linked resource --
#   nohref      (nohref)       #IMPLIED  -- this region has no action --
#   alt         %Text;         #REQUIRED -- short description --
#   tabindex    NUMBER         #IMPLIED  -- position in tabbing order --
#   accesskey   %Character;    #IMPLIED  -- accessibility key character --
#   onfocus     %Script;       #IMPLIED  -- the element got the focus --
#   onblur      %Script;       #IMPLIED  -- the element lost the focus --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-26019118
# interface HTMLAreaElement : HTMLElement {
#            attribute DOMString       accessKey;
#            attribute DOMString       alt;
#            attribute DOMString       coords;
#            attribute DOMString       href;
#            attribute boolean         noHref;
#            attribute DOMString       shape;
#            attribute long            tabIndex;
#            attribute DOMString       target;
# };
module RDom
  module Element
    module Area
      include Element, Node

      html_attributes :accessKey, :alt, :coords, :href, :noHref, :shape, 
                     :tabIndex, :target, :onfocus, :onblur
    end
  end
end