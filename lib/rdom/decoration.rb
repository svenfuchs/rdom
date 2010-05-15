require 'core_ext/string/titleize'

module RDom
  class << self
    def decorate(node)
      case node
      when LibXML::XML::Document
        node.extend(RDom::Document)
      when LibXML::XML::Node
        decorate_node(node)
      when LibXML::XML::Attributes
        node.extend(RDom::NamedNodeMap)
      end
    end

    def decorate_node(node)
      node.extend(RDom::Node)
      case node.node_type
      when LibXML::XML::Node::ELEMENT_NODE
        extensions = [RDom::Element]
        extensions << Element.const_get(node.name.titleize) rescue NameError
        extensions.each { |extension| node.extend(extension) }
      when LibXML::XML::Node::ATTRIBUTE_NODE
        # ?
      end
    end
  end

  module Decoration
    def decorated?
      @decorated
    end

    def decorate!
      RDom.decorate(self)
      @decorated = true
    end

    def respond_to?(name)
      decorated? ? super : decorate! && respond_to?(name)
    end
    
    def method_missing(name, *args, &block)
      decorated? ? super : decorate! && send(name, *args, &block)
    end
  end
end