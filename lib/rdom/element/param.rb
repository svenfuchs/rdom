# http://www.w3.org/TR/html401/struct/objects.html#edef-PARAM
# <!ELEMENT PARAM - O EMPTY              -- named property value -->
# <!ATTLIST PARAM
#   id          ID             #IMPLIED  -- document-wide unique id --
#   name        CDATA          #REQUIRED -- property name --
#   value       CDATA          #IMPLIED  -- property value --
#   valuetype   (DATA|REF|OBJECT) DATA   -- How to interpret value --
#   type        %ContentType;  #IMPLIED  -- content type for value
#                                           when valuetype=ref --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-64077273
# interface HTMLParamElement : HTMLElement {
#            attribute DOMString       name;
#            attribute DOMString       type;
#            attribute DOMString       value;
#            attribute DOMString       valueType;
# };
module RDom
  module Element
    module Param
      include Element, Node

      html_attributes :name, :type, :value, :valueType
    end
  end
end