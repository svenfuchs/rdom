# http://www.w3.org/TR/html401/present/frames.html#h-16.2.2
# <![ %HTML.Frameset; [
# <!-- reserved frame names start with "_" otherwise starts with letter -->
# <!ELEMENT FRAME - O EMPTY              -- subwindow -->
# <!ATTLIST FRAME
#   %coreattrs;                          -- id, class, style, title --
#   longdesc    %URI;          #IMPLIED  -- link to long description
#                                           (complements title) --
#   name        CDATA          #IMPLIED  -- name of frame for targetting --
#   src         %URI;          #IMPLIED  -- source of frame content --
#   frameborder (1|0)          1         -- request frame borders? --
#   marginwidth %Pixels;       #IMPLIED  -- margin widths in pixels --
#   marginheight %Pixels;      #IMPLIED  -- margin height in pixels --
#   noresize    (noresize)     #IMPLIED  -- allow users to resize frames? --
#   scrolling   (yes|no|auto)  auto      -- scrollbar or none --
#   >
# ]]>
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-97790553
# interface HTMLFrameElement : HTMLElement {
#            attribute DOMString       frameBorder;
#            attribute DOMString       longDesc;
#            attribute DOMString       marginHeight;
#            attribute DOMString       marginWidth;
#            attribute DOMString       name;
#            attribute boolean         noResize;
#            attribute DOMString       scrolling;
#            attribute DOMString       src;
#   // Introduced in DOM Level 2:
#   readonly attribute Document        contentDocument;
# };
module RDom
  module Element
    module Frame
      include Element, Node

      dom_attributes :frameBorder, :longDesc, :marginHeight, :marginWidth, :name,
                     :noResize, :scrolling, :src

      attr_reader :contentWindow

      def contentWindow=(window)
        @contentWindow = window
        window.parent.frames << window
      end
    end
  end
end