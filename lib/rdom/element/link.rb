# http://www.w3.org/TR/html401/struct/links.html#edef-LINK
# <!ELEMENT LINK - O EMPTY               -- a media-independent link -->
# <!ATTLIST LINK
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   charset     %Charset;      #IMPLIED  -- char encoding of linked resource --
#   href        %URI;          #IMPLIED  -- URI for linked resource --
#   hreflang    %LanguageCode; #IMPLIED  -- language code --
#   type        %ContentType;  #IMPLIED  -- advisory content type --
#   rel         %LinkTypes;    #IMPLIED  -- forward link types --
#   rev         %LinkTypes;    #IMPLIED  -- reverse link types --
#   media       %MediaDesc;    #IMPLIED  -- for rendering on these media --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-35143001
# interface HTMLLinkElement : HTMLElement {
#            attribute boolean         disabled;
#            attribute DOMString       charset;
#            attribute DOMString       href;
#            attribute DOMString       hreflang;
#            attribute DOMString       media;
#            attribute DOMString       rel;
#            attribute DOMString       rev;
#            attribute DOMString       target;
#            attribute DOMString       type;
# };
module RDom
  module Element
    module Link
      include Element, Node

      html_attributes :disabled, :charset, :href, :hreflang, :media, :rel, :rev,
                     :target, :type
    end
  end
end