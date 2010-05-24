# http://www.w3.org/TR/html401/struct/global.html#edef-META
# <!ELEMENT META - O EMPTY               -- generic metainformation -->
# <!ATTLIST META
#   %i18n;                               -- lang, dir, for use with content --
#   http-equiv  NAME           #IMPLIED  -- HTTP response header name  --
#   name        NAME           #IMPLIED  -- metainformation name --
#   content     CDATA          #REQUIRED -- associated information --
#   scheme      CDATA          #IMPLIED  -- select form of content --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-37041454
# interface HTMLMetaElement : HTMLElement {
#            attribute DOMString       content;
#            attribute DOMString       httpEquiv;
#            attribute DOMString       name;
#            attribute DOMString       scheme;
# };
module RDom
  module Element
    module Meta
      include Element, Node

      html_attributes :name, :content, :scheme, *ATTRS_I18N
      properties :httpEquiv
      
      def httpEquiv
        getAttribute('http-equiv').to_s
      end
      
      def httpEquiv=(value)
        setAttribute('http-equiv', value.to_s)
      end
    end
  end
end