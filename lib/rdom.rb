require 'xml'
require 'nokogiri'
require 'nokogiri/xml_pp_node_patch'

module RDom
  autoload :Attr,             'rdom/attr'
  autoload :Attributes,       'rdom/attributes'
  autoload :Document,         'rdom/document'
  autoload :DocumentFragment, 'rdom/document_fragment'
  autoload :DomAttributes,    'rdom/dom_attributes'
  autoload :Decoration,       'rdom/decoration'
  autoload :Element,          'rdom/element'
  autoload :Event,            'rdom/event'
  autoload :Location,         'rdom/location.rb'
  autoload :Node,             'rdom/node'
  autoload :NodeList,         'rdom/node_list'
  autoload :Properties,       'rdom/properties'
  autoload :Window,           'rdom/window'
end

Kernel.send :alias_method, :ruby_class, :class
Module.send :include, RDom::Properties, RDom::DomAttributes

Exception.properties :message

class Nokogiri::XML::Document
  include RDom::Document
end

class Nokogiri::XML::DocumentFragment
  include RDom::DocumentFragment
end

class Nokogiri::XML::NodeSet
  include RDom::NodeList
end

class Nokogiri::XML::Element
  include RDom::Element
end

class Nokogiri::XML::Attr
  alias :nokogiri_value :value
  remove_method :value
  include RDom::Attr
end

class Nokogiri::XML::Text
  def text
    textContent
  end
end

class Nokogiri::XML::Comment
  def text
    textContent
  end
end

class Nokogiri::XML::Node
  alias :node_elements :elements
  alias :node_text :text
  alias :node_name :name
  alias :node_attributes :attributes
  remove_method :elements, :text, :name, :attributes, :[], :[]=
  include RDom::Node

  def inspect_attributes
    [:node_name, :namespace, :attribute_nodes, :children]
  end
end