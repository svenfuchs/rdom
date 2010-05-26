# http://www.w3.org/TR/html401/present/styles.html#edef-STYLE
# <!ELEMENT STYLE - - %StyleSheet        -- style info -->
# <!ATTLIST STYLE
#   %i18n;                               -- lang, dir, for use with title --
#   type        %ContentType;  #REQUIRED -- content type of style language --
#   media       %MediaDesc;    #IMPLIED  -- designed for use with these media --
#   title       %Text;         #IMPLIED  -- advisory title --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-16428977
# interface HTMLStyleElement : HTMLElement {
#            attribute boolean         disabled;
#            attribute DOMString       media;
#            attribute DOMString       type;
# };
module RDom
  module Element
    module Style
      include Element, Node

      dom_attributes :type, :media, :title, :disabled, *ATTRS_I18N
    end
  end
end