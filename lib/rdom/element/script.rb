# http://www.w3.org/TR/html401/interact/scripts.html#edef-SCRIPT
# <!ELEMENT SCRIPT - - %Script;          -- script statements -->
# <!ATTLIST SCRIPT
#   charset     %Charset;      #IMPLIED  -- char encoding of linked resource --
#   type        %ContentType;  #REQUIRED -- content type of script language --
#   src         %URI;          #IMPLIED  -- URI for an external script --
#   defer       (defer)        #IMPLIED  -- UA may defer execution of script --
#   event       CDATA          #IMPLIED  -- reserved for possible future use --
#   for         %URI;          #IMPLIED  -- reserved for possible future use --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-81598695
# interface HTMLScriptElement : HTMLElement {
#            attribute DOMString       text;
#            attribute DOMString       htmlFor;
#            attribute DOMString       event;
#            attribute DOMString       charset;
#            attribute boolean         defer;
#            attribute DOMString       src;
#            attribute DOMString       type;
# };
module RDom
  module Element
    module Script
      include Element, Node

      class << self
        def process(node)
          node.ownerDocument.defaultView.send(:process_script, node) if node.ownerDocument.defaultView
        end
      end

      dom_attributes :charset, :type, :src, :defer, :event
      properties :htmlFor, :text

      # def appendChild(node)
      #   super
      #   Element::Script.process(node)
      # end

      # # http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-213157251
      # The for attribute of the LABEL and SCRIPT elements collides with loop 
      # construct naming conventions and is renamed htmlFor.
      def htmlFor
        getAttribute('for').to_s
      end

      def htmlFor=(value)
        setAttribute('for', value.to_s)
      end
      
      # The script content of the element.
      def text
        textContent
      end
      
      # The script content of the element.
      def text=(text)
        textContent = text
      end
    end
  end
end