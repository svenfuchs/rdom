require 'core_ext/string/titleize'

module RDom
  module Element
    module Decoration
      def self.extended(node)
        case node.node_type
        when Nokogiri::XML::Node::ELEMENT_NODE
          const_name = node.nodeName.titleize
          node.extend(Element.const_get(const_name)) if Element.const_defined?(const_name)
        end
      end
    end

    Dir[File.expand_path('../element/*.rb', __FILE__)].each do |file|
      autoload File.basename(file, '.rb').titleize.to_sym, file
    end

    ATTRS_CORE   = [:id, :style, :title, :class]
    ATTRS_I18N   = [:lang, :dir]
    ATTRS_EVENTS = [:onclick, :ondblclick, :onmousedown, :onmouseup, :onmouseover,
                    :onmousemove, :onkeypress, :onkeydown, :onkeyup]

    dom_attributes :align, *ATTRS_CORE + ATTRS_I18N + ATTRS_EVENTS
    properties :tagName, :className, :innerHTML

    def tagName
      nodeName.upcase
    end

    # # http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-213157251
    # The class attribute of the HTML elements collides with class definitions
    # naming conventions and is renamed className.
    def className
      getAttribute('class').to_s
    end

    def className=(value)
      setAttribute('class', value.to_s)
    end

    def style
      @style ||= begin
        node  = getAttributeNode('style')
        # style = Css::StyleDeclaration.new(self, node ? node.value : nil)
        {}
      end
    end

    def style=(value)
      raise "read-only?"
    end

    def innerHTML
      inner_html
    end

    def innerHTML=(html)
      children.each { |child| child.remove }

      leading, trailing = html.scan(/^[\s]*|[\s]*$/m)
      fragment = Nokogiri::HTML::DocumentFragment.parse(html)

      self << document.create_text_node(leading) unless leading.blank?
      fragment.childNodes.each { |node| self << node }
      self << document.create_text_node(trailing) unless trailing.blank?
    end

    def getElementsByTagName(tag_name)
      xpath(".//#{tag_name}").to_a
    end

    # https://developer.mozilla.org/en/DOM:element.getAttributeNode
    # When called on an HTML element in a DOM flagged as an HTML document,
    # getAttributeNode lower-cases its argument before proceeding.
    def hasAttribute(name)
      !!has_attribute?(name.to_s.downcase)
    end

    def getAttribute(name)
      node = getAttributeNode(name)
      node.value if node
    end

    def getAttributeNode(name)
      attribute(name.to_s.downcase)
    end

    def setAttribute(name, value)
      set_attribute(name.to_s.downcase, Attr.serialize(name, value))
    end

    def setAttributeNode(attribute)
      # TODO - how to set an actual attribute node with Nokogiri?
      setAttribute(attribute.name, attribute.value)
    end

    def removeAttribute(name)
      attribute = removeAttributeNode(name.to_s.downcase)
      attribute.value if attribute
    end

    def removeAttributeNode(name)
      attribute = getAttributeNode(name)
      attribute.remove if attribute
      attribute
    end
  end
end