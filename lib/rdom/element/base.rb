# http://www.w3.org/TR/html401/struct/links.html#edef-BASE
# <!ELEMENT BASE - O EMPTY               -- document base URI -->
# <!ATTLIST BASE
#   href        %URI;          #REQUIRED -- URI that acts as base URI --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-73629039
# interface HTMLBaseElement : HTMLElement {
#            attribute DOMString       href;
#            attribute DOMString       target;
# };

module RDom
  module Element
    module Base
      include Element, Node
      
      html_attributes :href, :target
    end
  end
end