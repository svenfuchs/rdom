# http://www.w3.org/TR/html401/present/frames.html#h-16.2.1
# <![ %HTML.Frameset; [
# <!ELEMENT FRAMESET - - ((FRAMESET|FRAME)+ & NOFRAMES?) -- window subdivision-->
# <!ATTLIST FRAMESET
#   %coreattrs;                          -- id, class, style, title --
#   rows        %MultiLengths; #IMPLIED  -- list of lengths,
#                                           default: 100% (1 row) --
#   cols        %MultiLengths; #IMPLIED  -- list of lengths,
#                                           default: 100% (1 col) --
#   onload      %Script;       #IMPLIED  -- all the frames have been loaded  -- 
#   onunload    %Script;       #IMPLIED  -- all the frames have been removed -- 
#   >
# ]]>
# 
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-43829095
# interface HTMLFrameSetElement : HTMLElement {
#            attribute DOMString       cols;
#            attribute DOMString       rows;
# };
module RDom
  module Element
    module Frameset
      include Element, Node

      dom_attributes :cols, :rows, :onload, :onunload
    end
  end
end