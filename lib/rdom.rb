require 'xml'
require 'libxml'
require 'treetop_css'

module RDom
  autoload :Attr,             'rdom/attr'
  autoload :Attribute,        'rdom/attribute'
  autoload :Css,              'rdom/css'
  autoload :Document,         'rdom/document'
  autoload :DocumentFragment, 'rdom/document_fragment'
  autoload :Decoration,       'rdom/decoration'
  autoload :Element,          'rdom/element'
  autoload :Event,            'rdom/event'
  autoload :Location,         'rdom/location.rb'
  autoload :NamedNodeMap,     'rdom/named_node_map'
  autoload :Node,             'rdom/node'
  autoload :NodeList,         'rdom/node_list'
  autoload :Properties,       'rdom/properties'
  autoload :Window,           'rdom/window'

  HTML_PARSE_OPTIONS = XML::Parser::Options::RECOVER |
    XML::Parser::Options::NOERROR |
    XML::Parser::Options::NOWARNING
end

Module.send :include, RDom::Properties
Class.send :include, RDom::Properties

consts = [
  LibXML::XML::Document, LibXML::XML::Node, LibXML::XML::Attr, LibXML::XML::Attributes,
  # CssParser::RuleSet
]
consts.each do |const|
  const.class_eval do
    include RDom::Decoration
    undef :id, :type
  end
end

LibXML::XML::Node.class_eval do
  alias :node_name :name
  undef :[], :[]=, :name
end

LibXML::XML::Attributes.class_eval do
  undef :[], :[]=
end

Exception.class_eval do
  def js_property?(name)
    name == :message
  end
end
