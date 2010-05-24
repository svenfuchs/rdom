# http://www.w3.org/TR/html401/struct/links.html#edef-A
# <!ELEMENT A - - (%inline;)* -(A)       -- anchor -->
# <!ATTLIST A
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   charset     %Charset;      #IMPLIED  -- char encoding of linked resource --
#   type        %ContentType;  #IMPLIED  -- advisory content type --
#   name        CDATA          #IMPLIED  -- named link end --
#   href        %URI;          #IMPLIED  -- URI for linked resource --
#   hreflang    %LanguageCode; #IMPLIED  -- language code --
#   rel         %LinkTypes;    #IMPLIED  -- forward link types --
#   rev         %LinkTypes;    #IMPLIED  -- reverse link types --
#   accesskey   %Character;    #IMPLIED  -- accessibility key character --
#   shape       %Shape;        rect      -- for use with client-side image maps --
#   coords      %Coords;       #IMPLIED  -- for use with client-side image maps --
#   tabindex    NUMBER         #IMPLIED  -- position in tabbing order --
#   onfocus     %Script;       #IMPLIED  -- the element got the focus --
#   onblur      %Script;       #IMPLIED  -- the element lost the focus --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-48250443
# interface HTMLAnchorElement : HTMLElement {
#            attribute DOMString       accessKey;
#            attribute DOMString       charset;
#            attribute DOMString       coords;
#            attribute DOMString       href;
#            attribute DOMString       hreflang;
#            attribute DOMString       name;
#            attribute DOMString       rel;
#            attribute DOMString       rev;
#            attribute DOMString       shape;
#            attribute long            tabIndex;
#            attribute DOMString       target;
#            attribute DOMString       type;
#   void               blur();
#   void               focus();
# };

module RDom
  module Element
    module A
      include Element, Node

      html_attributes :accessKey, :charset, :coords, :href, :hreflang, :name,
                     :rel, :rev, :shape, :tabIndex, :target, :type, :onfocus, 
                     :onblur
    end
  end
end