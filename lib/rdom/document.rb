module RDom
  module Document
    include Event::Target

    class << self
      def new(window, html, options = {})
        document = parse(html)
        document.window = window
        document.url = options[:url]
        document.referrer = options[:referrer]
        document.decorators(Nokogiri::XML::Element) << RDom::Element::Decoration
        document
      end

      def parse(html)
        html = '<html />' if html.nil? || html.empty?
        Nokogiri::HTML(html)
      end
    end

    properties :nodeType, :nodeName, :nodeValue, :documentElement, :defaultView,
               :location, :URL, :referrer, :domain, :title, :body, :images,
               :links, :forms, :anchors, :styleSheets

    attr_accessor :window, :url, :referrer

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
      Nokogiri::XML::Node::DOCUMENT_NODE
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

    def ownerDocument
      nil
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
      xpath("//#{tag_name}").to_a
    end

    def getElementById(id)
      xpath("//*[@id='#{id}']").first
    end

    def getElementsByName(name)
      xpath("//*[@name='#{name}']").first
    end

    def title
      node = getElementsByTagName('title').first
      node ? node.content : ''
    end

    def title=(title)
      node = getElementsByTagName('title').first
      node ||= create_title_tag
      node.content = title
    end

    def body
      getElementsByTagName('body').first
    end

    def images
      getElementsByTagName('img')
    end

    def links
      xpath('//a[@href]|//area[@href]').to_a
    end

    def forms
      getElementsByTagName('form')
    end

    def anchors
      xpath('//a[@name]').to_a
    end

    def importNode(node)
      node.cloneNode(true)
    end

    def styleSheets
      getElementsByTagName('style').inject([]) do |style_sheets, tag|
        style_sheets << Css::StyleSheet.parse(tag.textContent)
      end
    end

    protected

      def create_title_tag
        head = getElementsByTagName('head').first || create_head_tag
        head.appendChild(createElement('title'))
      end

      def create_head_tag
        head = createElement('head')
        documentElement.insertBefore(head, documentElement.firstChild)
        head
      end
  end
end