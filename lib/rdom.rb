require 'xml'
require 'nokogiri'

module RDom
  autoload :Attr,             'rdom/attr'
  autoload :Attributes,       'rdom/attributes'
  autoload :Document,         'rdom/document'
  autoload :Decoration,       'rdom/decoration'
  autoload :Element,          'rdom/element'
  autoload :Event,            'rdom/event'
  autoload :Location,         'rdom/location.rb'
  autoload :Node,             'rdom/node'
  autoload :NodeList,         'rdom/node_list'
  autoload :Properties,       'rdom/properties'
  autoload :Window,           'rdom/window'
end

Class.send :include, RDom::Properties
Module.send :include, RDom::Properties
Kernel.send :alias_method, :ruby_class, :class

class Nokogiri::XML::Document
  include RDom::Document

  def decorate(object)
    RDom::Decoration.decorate(object)
  end
end

class Nokogiri::XML::DocumentFragment
  # can't include this as a module?
  def nodeName
    '#document_fragment'
  end
end

class Nokogiri::XML::NodeSet
  include RDom::NodeList
end

class Nokogiri::XML::Attr
  alias :nokogiri_value :value
  remove_method :value
  include RDom::Attr
end

class Nokogiri::XML::Node
  alias :node_name :name
  alias :node_attributes :attributes
  remove_method :attributes, :[], :[]=
  include RDom::Node

  def inspect_attributes
    [:node_name, :namespace, :attribute_nodes, :children]
  end
end

Exception.class_eval do
  properties :message
end

module Nokogiri::XML::PP::Node
  def inspect
    attributes = inspect_attributes.reject { |x|
      begin
        attribute = send x
        !attribute || (attribute.respond_to?(:empty?) && attribute.empty?)
      rescue NoMethodError
        true
      end
    }.map { |attribute|
      "#{attribute.to_s.sub(/_\w+/, 's')}=#{send(attribute).inspect}"
    }.join ' '
    "#<#{self.ruby_class.name}:#{sprintf("0x%x", object_id)} #{attributes}>"
  end
end
