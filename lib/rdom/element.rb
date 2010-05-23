module RDom
  module Element
    autoload :A,        'rdom/element/a'
    autoload :Link,     'rdom/element/link'
    autoload :Meta,     'rdom/element/meta'
    autoload :Style,    'rdom/element/style'
    autoload :Body,     'rdom/element/body'
    autoload :Form,     'rdom/element/form'
    autoload :Select,   'rdom/element/select'
    autoload :Option,   'rdom/element/option'
    autoload :Input,    'rdom/element/input'
    autoload :Textarea, 'rdom/element/textarea'
    autoload :Button,   'rdom/element/button'
    autoload :Label,    'rdom/element/label'
    autoload :Fieldset, 'rdom/element/fieldset'
    autoload :Legend,   'rdom/element/legend'
    autoload :Ul,       'rdom/element/ul'
    autoload :Ol,       'rdom/element/ol'
    autoload :Li,       'rdom/element/li'
    autoload :Pre,      'rdom/element/pre'
    autoload :Image,    'rdom/element/image'
    autoload :Object,   'rdom/element/object'
    autoload :Param,    'rdom/element/param'
    autoload :Map,      'rdom/element/map'
    autoload :Area,     'rdom/element/area'
    autoload :Script,   'rdom/element/script'
    autoload :Table,    'rdom/element/table'
    autoload :Tr,       'rdom/element/tr'
    autoload :Td,       'rdom/element/td'
    autoload :Th,       'rdom/element/th'
    autoload :Frame,    'rdom/element/frame'
    autoload :IFrame,   'rdom/element/iframe'

    properties :tagName, :className, :innerHTML, :style
    dom_attributes :id, :title, :lang, :dir

    def tagName
      nodeName.upcase
    end

    def className
      getAttribute('class').to_s
    end

    def className=(value)
      setAttribute('class', value.to_s)
    end

    def style
      @style ||= Css::StyleDeclaration.new(self, getAttribute('style'))
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
      node = attributes.get_attribute(name.to_s.downcase)
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
      attribute.value
    end

    def removeAttributeNode(name)
      attribute = attributes.get_attribute(name.downcase)
      attribute.remove! if attribute
      attribute
    end
  end
end