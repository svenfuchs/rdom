require 'core_ext/string/titleize'

module RDom
  class << self
    def decorate(node)
      case node
      when LibXML::XML::Attr
        node.extend(Attr)
      when LibXML::XML::Document
        node.extend(Document)
      when LibXML::XML::Node
        decorate_node(node)
      when LibXML::XML::Attributes
        node.extend(NamedNodeMap)
      end
    end

    def decorate_node(node)
      node.extend(Node)
      case node.node_type
      when LibXML::XML::Node::ELEMENT_NODE
        node.extend(Element)
        node.extend(Element.const_get(node.nodeName.titleize)) rescue NameError
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