module RDom
  module Element
    Dir[File.expand_path('../element/*.rb', __FILE__)].each do |file|
      autoload File.basename(file, '.rb').titleize.to_sym, file
    end
    
    ATTRS_CORE   = [:id, :style, :title, :class]
    ATTRS_I18N   = [:lang, :dir]
    ATTRS_EVENTS = [:onclick, :ondblclick, :onmousedown, :onmouseup, :onmouseover, 
                    :onmousemove, :onkeypress, :onkeydown, :onkeyup]

    html_attributes :align, *ATTRS_CORE + ATTRS_I18N + ATTRS_EVENTS
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
      getAttribute('style') || Css::StyleDeclaration.new(self, '')
    end
    
    def style=(value)
      raise "read-only?"
    end

    def innerHTML
      # child.to_s
      inner_xml
    end

    def innerHTML=(html)
      children.each { |child| child.remove! }
      unless html.nil? || html.empty?
        DocumentFragment.parse(html).childNodes.each do |node|
          node = doc.import(node) if doc && doc != node.doc
          self << node
        end
      end
    end

    def getElementsByTagName(tag_name)
      find(".//#{tag_name}").to_a
    end

    # https://developer.mozilla.org/en/DOM:element.getAttributeNode
    # When called on an HTML element in a DOM flagged as an HTML document,
    # getAttributeNode lower-cases its argument before proceeding.

    def hasAttribute(name)
      !!attributes.get_attribute(name.downcase)
    end

    def getAttribute(name)
      node = getAttributeNode(name)
      node.value if node
    end

    def getAttributeNode(name)
      node = attributes.getNamedItem(name.to_s.downcase)
      node.decorate! if node
      node
    end

    def setAttribute(name, value)
      value = value == 'checked' || TrueClass === value if name.to_sym == :checked
      node = getAttributeNode(name)
      node ||= setAttributeNode(ownerDocument.createAttribute(name))
      node.value = value.to_s
    end

    def setAttributeNode(attribute)
      removeAttributeNode(attribute.name)
      node = LibXML::XML::Attr.new(self, attribute.name.downcase, attribute.value || '')
      node.specified = false
      node
    end

    def removeAttribute(name)
      attribute = removeAttributeNode(name.downcase)
      attribute.value if attribute
    end

    def removeAttributeNode(name)
      attribute = attributes.get_attribute(name.downcase)
      attribute.remove! if attribute
      attribute
    end
  end
end