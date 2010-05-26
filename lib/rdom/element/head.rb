# http://www.w3.org/TR/html401/struct/global.html#edef-HEAD
# <!ELEMENT HEAD O O (%head.content;) +(%head.misc;) -- document head -->
# <!ATTLIST HEAD
#   %i18n;                               -- lang, dir --
#   profile     %URI;          #IMPLIED  -- named dictionary of meta info --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-77253168
# interface HTMLHeadElement : HTMLElement {
#            attribute DOMString       profile;
# };
module RDom
  module Element
    module Head
      include Element, Node

      dom_attributes :profile
    end
  end
end