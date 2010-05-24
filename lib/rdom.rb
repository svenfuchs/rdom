require 'xml'
require 'libxml'
require 'treetop_css'

module RDom
  autoload :Attr,             'rdom/attr'
  autoload :Attribute,        'rdom/attribute'
  autoload :Attributes,       'rdom/attributes'
  autoload :Css,              'rdom/css'
  autoload :Document,         'rdom/document'
  autoload :DocumentFragment, 'rdom/document_fragment'
  autoload :Decoration,       'rdom/decoration'
  autoload :Element,          'rdom/element'
  autoload :Event,            'rdom/event'
  autoload :Location,         'rdom/location.rb'
  autoload :Node,             'rdom/node'
  autoload :NodeList,         'rdom/node_list'
  autoload :Properties,       'rdom/properties'
  autoload :Window,           'rdom/window'

  HTML_PARSE_OPTIONS = XML::Parser::Options::RECOVER |
    XML::Parser::Options::NOERROR |
    XML::Parser::Options::NOWARNING
end

Class.send :include, RDom::Properties
Module.send :include, RDom::Properties
Kernel.send :alias_method, :ruby_class, :class

consts = [
  LibXML::XML::Document, 
  LibXML::XML::Node, 
  LibXML::XML::Attr, 
  LibXML::XML::Attributes
]
consts.each do |const|
  const.class_eval do
    include RDom::Decoration
    undef :id, :type
  end
end

LibXML::XML::Attributes.class_eval do
  undef :[], :[]=, :class
end

LibXML::XML::Node.class_eval do
  # alias :node_text :text
  alias :node_name :name
  undef :[], :[]=, :name, :class
end

Exception.class_eval do
  def js_property?(name)
    name == :message
  end
end
