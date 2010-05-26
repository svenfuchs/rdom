# http://www.w3.org/TR/html401/struct/text.html#edef-ins
# <!-- INS/DEL are handled by inclusion on BODY -->
# <!ELEMENT (INS|DEL) - - (%flow;)*      -- inserted text, deleted text -->
# <!ATTLIST (INS|DEL)
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   cite        %URI;          #IMPLIED  -- info on reason for change --
#   datetime    %Datetime;     #IMPLIED  -- date and time of change --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-79359609
# interface HTMLModElement : HTMLElement {
#            attribute DOMString       cite;
#            attribute DOMString       dateTime;
# };
module RDom
  module Element
    module Del
      include Element, Node

      dom_attributes :cite, :dateTime
    end
  end
end