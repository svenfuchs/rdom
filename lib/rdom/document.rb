module RDom
  module Document
    include Properties, Event::Target
    
    class << self
      def new(window, html, options = {})
        parse_options = XML::Parser::Options::RECOVER
        document = LibXML::XML::HTMLParser.string(html, :options => parse_options).parse
        document.instance_variable_set(:@window, window)
        document.instance_variable_set(:@url, options[:url])
        document.instance_variable_set(:@referrer, options[:referrer])
        document
      end
    end

    PROPERTIES = [
      :nodeType, :nodeName, :nodeValue, :documentElement, :defaultView, 
      :location, :URL, :referrer, :domain, :title, :body, :images, :links,
      :forms, :anchors
    ]

    def createDocumentFragment
      createElement('document_fragment') # TODO ask libxml how to do this appropriately, doc has to be set
    end
    
    def createElement(name)
      import XML::Node.new(name)
    end

    def createAttribute(name)
      Attr.new(self, name)
    end
    
    def createComment(data)
      import XML::Node.new_comment(data)
    end
    
    def createTextNode(data)
      import XML::Node.new_text(data)
    end

    def createEvent(type)
      Event.new(type)
    end

    def nodeType
      XML::Node::DOCUMENT_NODE
    end
    
    def nodeName
      '#document'
    end

    def nodeValue
      nil
    end

    def documentElement
      root
    end
    
    def defaultView
      @window
    end
    
    def location
      @location ||= Location.new(defaultView, @url)
    end
    
    def URL
      @url
    end
    
    def referrer
      @referrer
    end
    
    def domain
      location.hostname
    end

    def getElementsByTagName(tag_name)
      find("//#{tag_name}").to_a
    end

    def getElementById(id)
      find_first("//*[@id='#{id}']")
    end
    
    def getElementsByName(name)
      find_first("//*[@name='#{name}']")
    end
    
    def title
      node = find_first('//title')
      node ? node.content : ''
    end
    
    def title=(title)
      node = find_first('//title')
      node.content = title # TODO implicitely create head/title tags unless present
    end
    
    def body
      find_first('//body')
    end
    
    def images
      find('//img')
    end
    
    def links
      find('//a[@href]|//area[@href]')
    end
    
    def forms
      find('//form')
    end
    
    def anchors
      find('//a[@name]')
    end
    
    def importNode(node)
      import node.cloneNode(true)
    end
  end
end