# http://www.w3.org/TR/html401/struct/global.html#edef-BODY
# <!ELEMENT BODY O O (%block;|SCRIPT)+ +(INS|DEL) -- document body -->
# <!ATTLIST BODY
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   onload          %Script;   #IMPLIED  -- the document has been loaded --
#   onunload        %Script;   #IMPLIED  -- the document has been removed --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-62018039
# interface HTMLBodyElement : HTMLElement {
#            attribute DOMString       aLink;
#            attribute DOMString       background;
#            attribute DOMString       bgColor;
#            attribute DOMString       link;
#            attribute DOMString       text;
#            attribute DOMString       vLink;
# };

module RDom
  module Element
    module Body
      include Element, Node

      dom_attributes :background, :bgColor, :link, :text, :aLink, :vLink, 
                     :onload, :onunload
    end
  end
end