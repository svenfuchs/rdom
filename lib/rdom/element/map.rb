# http://www.w3.org/TR/html401/struct/objects.html#edef-MAP
# <!ELEMENT MAP - - ((%block;) | AREA)+ -- client-side image map -->
# <!ATTLIST MAP
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   name        CDATA          #REQUIRED -- for reference by usemap --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-94109203
# interface HTMLMapElement : HTMLElement {
#   readonly attribute HTMLCollection  areas;
#            attribute DOMString       name;
# };
module RDom
  module Element
    module Map
      include Element, Node

      html_attributes :name
      properties :areas
      
      def areas
        find('.//area').to_a
      end
    end
  end
end