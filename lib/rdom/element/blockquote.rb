# http://www.w3.org/TR/html401/struct/text.html#edef-Q
# <!ELEMENT BLOCKQUOTE - - (%block;|SCRIPT)+ -- long quotation -->
# <!ATTLIST BLOCKQUOTE
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   cite        %URI;          #IMPLIED  -- URI for source document or msg --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-70319763
# interface HTMLQuoteElement : HTMLElement {
#            attribute DOMString       cite;
# };
module RDom
  module Element
    module Blockquote
      include Element, Node

      html_attributes :cite
    end
  end
end