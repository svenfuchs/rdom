# http://www.w3.org/TR/html401/interact/forms.html#edef-FORM
# <!ELEMENT FORM - - (%block;|SCRIPT)+ -(FORM) -- interactive form -->
# <!ATTLIST FORM
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   action      %URI;          #REQUIRED -- server-side form handler --
#   method      (GET|POST)     GET       -- HTTP method used to submit the form--
#   enctype     %ContentType;  "application/x-www-form-urlencoded"
#   accept      %ContentTypes; #IMPLIED  -- list of MIME types for file upload --
#   name        CDATA          #IMPLIED  -- name of form for scripting --
#   onsubmit    %Script;       #IMPLIED  -- the form was submitted --
#   onreset     %Script;       #IMPLIED  -- the form was reset --
#   accept-charset %Charsets;  #IMPLIED  -- list of supported charsets --
#   >
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-40002357
# interface HTMLFormElement : HTMLElement {
#   readonly attribute HTMLCollection  elements;
#   readonly attribute long            length;
#            attribute DOMString       name;
#            attribute DOMString       acceptCharset;
#            attribute DOMString       action;
#            attribute DOMString       enctype;
#            attribute DOMString       method;
#            attribute DOMString       target;
#   void               submit();
#   void               reset();
# };
module RDom
  module Element
    module Form
      include Element, Node

      # TODO :method somehow breaks jquery tests, maybe in johnson?
      html_attributes :name, :action, :enctype, :target, :accept, :onsubmit, :onreset
      
      properties :elements, :length, :acceptCharset
      
      def acceptCharset
        getAttribute('accept-charset').to_s
      end
      
      def acceptCharset=(value)
        setAttribute('accept-charset', value.to_s)
      end

      def elements
        find('.//input|.//textarea|.//select|.//button').to_a
      end
      
      def length
        elements.size
      end
      
      # TODO submit, reset
    end
  end
end