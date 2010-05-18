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
  
    properties :tagName, :className, :innerHTML, :id, :title, :lang, :dir,
               :style, :documentElement

    
    def tagName
      nodeName.upcase
    end
    
    def className
      libxml_read_attribute('class') || ''
    end
    
    def className=(value)
      libxml_write_attribute('class', value.to_s)
    end
    
    def style
      libxml_read_attribute('style') || { }
    end
  
    def innerHTML
      # child.to_s
      inner_xml
    end
  
    def innerHTML=(html)
      children.each { |child| child.remove! }
      appendChild(DocumentFragment.parse(html)) unless html.nil? || html.empty?
    end
  
    def getElementsByTagName(tag_name)
      find(".//#{tag_name}").to_a
    end
  
    def hasAttribute(name)
      !!attributes.get_attribute(name)
    end
  
    def getAttribute(name)
      # node = getAttributeNode(name)
      # node.value if node
      libxml_read_attribute(name)
    end
  
    def getAttributeNode(name)
      attributes.get_attribute(name)
    end
  
    def setAttribute(name, value)
      libxml_write_attribute(name, value)
    end
  
    def setAttributeNode(attribute)
      LibXML::XML::Attr.new(self, attribute.name, attribute.value)
    end
  
    def removeAttribute(name)
      attribute = attributes.get_attribute(name)
      attribute.remove! if attribute
    end
  end
end