require 'xml'
require 'libxml'

module RDom
  autoload :Attr,         'rdom/attr'
  autoload :Document,     'rdom/document'
  autoload :Decoration,   'rdom/decoration'
  autoload :Element,      'rdom/element'
  autoload :Event,        'rdom/event'
  autoload :Location,     'rdom/location.rb'
  autoload :NamedNodeMap, 'rdom/named_node_map'
  autoload :Node,         'rdom/node'
  autoload :NodeList,     'rdom/node_list'
  autoload :Properties,   'rdom/properties'
  autoload :Window,       'rdom/window'
end

[
  LibXML::XML::Document, 
  LibXML::XML::Node, 
  LibXML::XML::Attr,
  LibXML::XML::Attributes
].each { |const| const.send(:include, RDom::Decoration) }
