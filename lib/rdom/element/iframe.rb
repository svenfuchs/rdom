# http://www.w3.org/TR/html401/present/frames.html#h-16.5
# <!ELEMENT IFRAME - - (%flow;)*         -- inline subwindow -->
# <!ATTLIST IFRAME
#   %coreattrs;                          -- id, class, style, title --
#   longdesc    %URI;          #IMPLIED  -- link to long description
#                                           (complements title) --
#   name        CDATA          #IMPLIED  -- name of frame for targetting --
#   src         %URI;          #IMPLIED  -- source of frame content --
#   frameborder (1|0)          1         -- request frame borders? --
#   marginwidth %Pixels;       #IMPLIED  -- margin widths in pixels --
#   marginheight %Pixels;      #IMPLIED  -- margin height in pixels --
#   scrolling   (yes|no|auto)  auto      -- scrollbar or none --
#   align       %IAlign;       #IMPLIED  -- vertical or horizontal alignment --
#   height      %Length;       #IMPLIED  -- frame height --
#   width       %Length;       #IMPLIED  -- frame width --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-50708718
# interface HTMLIFrameElement : HTMLElement {
#            attribute DOMString       align;
#            attribute DOMString       frameBorder;
#            attribute DOMString       height;
#            attribute DOMString       longDesc;
#            attribute DOMString       marginHeight;
#            attribute DOMString       marginWidth;
#            attribute DOMString       name;
#            attribute DOMString       scrolling;
#            attribute DOMString       src;
#            attribute DOMString       width;
#   // Introduced in DOM Level 2:
#   readonly attribute Document        contentDocument;
# };
module RDom
  module Element
    module Iframe
      include Element, Node

      html_attributes :frameBorder, :height, :longDesc, :marginHeight, :marginWidth, :name,
                     :scrolling, :src, :width

      attr_reader :contentWindow

      def contentWindow=(window)
        @contentWindow = window
        window.parent.frames << window
      end
    end
  end
end