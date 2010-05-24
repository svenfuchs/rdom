require 'core_ext/string/titleize'

module RDom
  class << self
    def decorate(object)
      case object
      when LibXML::XML::Attr
        object.extend(Attr)
      when LibXML::XML::Attributes
        object.extend(RDom::Attributes)
      when LibXML::XML::Document
        object.extend(Document)
      when LibXML::XML::Node
        decorate_node(object)
      end
    end

    def decorate_node(node)
      node.extend(Node)
      case node.node_type
      when LibXML::XML::Node::ELEMENT_NODE
        const_name = node.nodeName.titleize
        extension = Element.const_defined?(const_name) ? Element.const_get(const_name) : Element
        node.extend(extension)
      end
    end
  end

  module Decoration
    def decorated?
      @decorated
    end

    def decorate!
      @decorated = true
      RDom.decorate(self)
    end

    def respond_to?(name)
      return super if decorated?
      decorate!
      respond_to?(name)
    end
    
    def method_missing(name, *args, &block)
      return super if decorated?
      decorate!
      send(name, *args, &block)
    end
  end
end