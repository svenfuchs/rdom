require 'core_ext/string/titleize'

module RDom
  module Decoration
    class << self
      def decorate(object)
        case object
        when Nokogiri::XML::Element
          decorate_node(object)
        end
      end

      def decorate_node(node)
        case node.node_type
        when Nokogiri::XML::Node::ELEMENT_NODE
          const_name = node.nodeName.titleize
          extension = Element.const_defined?(const_name) ? Element.const_get(const_name) : Element
          node.extend(extension)
        end
      end
    end
  end
end