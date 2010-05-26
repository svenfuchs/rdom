module RDom
  module Document
    include Event::Target

    class << self
      def new(window, html, options = {})
        document = parse(html)
        document.instance_variable_set(:@window, window)
        document.instance_variable_set(:@url, options[:url])
        document.instance_variable_set(:@referrer, options[:referrer])
        document
      end

      def parse(html)
        html = '<html />' if html.nil? || html.empty?
        Nokogiri::HTML(html)
      end
    end
    
    def find_first(path)
      xpath(path).first
    end
    
    def find(path)
      xpath(path)
    end

    properties :nodeType, :nodeName, :nodeValue, :documentElement, :defaultView,
               :location, :URL, :referrer, :domain, :title, :body, :images,
               :links, :forms, :anchors, :styleSheets

    def createDocumentFragment
      Nokogiri::HTML::DocumentFragment.new(self)
    end

    def createElement(name)
      Nokogiri::XML::Element.new(name.to_s, self)
    end

    def createAttribute(name)
      Nokogiri::XML::Attr.new(self, name.to_s)
    end

    def createComment(data)
      Nokogiri::XML::Comment.new(self, data)
    end

    def createTextNode(data)
      create_text_node(data)
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

    def parentNode
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

    def open
      # TODO
    end

    def close
      # TODO
    end

    def write(html)
      # TODO
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
      node ||= create_title_tag
      node.content = title
    end

    def body
      find_first('//body')
    end

    def images
      find('//img').to_a
    end

    def links
      find('//a[@href]|//area[@href]').to_a
    end

    def forms
      find('//form').to_a
    end

    def anchors
      find('//a[@name]').to_a
    end

    def importNode(node)
      node.cloneNode(true)
    end

    def styleSheets
      find('//style').inject([]) do |style_sheets, tag|
        style_sheets << Css::StyleSheet.parse(tag.textContent)
      end
    end

    protected

      def create_title_tag
        head = find_first('//head') || create_head_tag
        head.appendChild(createElement('title'))
      end

      def create_head_tag
        head = createElement('head')
        documentElement.insertBefore(head, documentElement.firstChild)
        head
      end
  end
end