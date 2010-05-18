require 'uri'

module RDom
  class Location
    include Decoration

    properties :href, :hash, :host, :hostname, :pathname, :port, :protocol, :search

    attr_reader :uri, :href, :window
  
    def initialize(window = nil, uri = '')
      @window = window
      @uri = URI.parse(uri || '')
    end

    def assign(url)
      @uri = parse_uri(url)
      window.history << url
      reload
    end
    alias :href= :assign
  
    def replace(url)
      window.history.pop
      assign(url)
    end
  
    def reload
      @href = uri.to_s
      window.load(href)
    end
  
    def hash
      "##{uri.fragment}"
    end
  
    def hash=(hash)
      uri.fragment = hash.gsub(/^#/, '')
      reload
    end
  
    def host
      "#{uri.host}:#{uri.port}"
    end
  
    def host=(host)
      uri.host, uri.port = host.split(':')
      reload
    end
  
    def hostname
      uri.host
    end
  
    def hostname=(hostname)
      uri.host = hostname
      reload
    end
  
    def pathname
      uri.path
    end
  
    def pathname=(pathname)
      pathname = "/#{pathname}" unless pathname =~ /^\//
      uri.path = pathname
      reload
    end
  
    def port
      uri.port.to_s
    end
  
    def port=(port)
      uri.port = port
      reload
    end
  
    def protocol
      "#{uri.scheme}:"
    end
  
    def protocol=(protocol)
      uri.scheme = protocol
      reload
    end
  
    def search
      uri.query ? "?#{uri.query}" : ''
    end
  
    def search=(search)
      uri.query = search.gsub(/^\?/, '')
      reload
    end
  
    def toString
      href
    end

    protected
    
      def set(uri)
        @uri = parse_uri(uri)
        @href = uri.to_s
        window.history << uri unless window.history.last == uri
      end
  
      def parse_uri(uri)
        uri = uri.is_a?(URI) ? uri : URI.parse(uri)
        (class << uri; self; end).send(:define_method, :default_port) { 0 }
        uri
      end
  end
end