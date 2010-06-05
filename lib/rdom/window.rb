require 'open-uri'
require 'johnson/tracemonkey'
require 'johnson/js_land_proxy_patch'

STDOUT.sync = true

module RDom
  class Window
    autoload :Console,   'rdom/window/console.rb'
    autoload :Frame,     'rdom/window/frame.rb'
    autoload :History,   'rdom/window/history.rb'
    autoload :Navigator, 'rdom/window/navigator.rb'
    autoload :Screen,    'rdom/window/screen.rb'
    autoload :Timers,    'rdom/window/timers.rb'

    include Event::Target, Window::Timers

    properties :location, :navigator, :url, :console, :parent, :name, :document,
               :defaultStatus, :history, :opener, :frames, :innerHeight, :innerWidth,
               :outerHeight, :outerWidth, :pageXOffset, :pageYOffset, :screenX,
               :screenY, :screenLeft, :screenTop

    attr_accessor *property_names

    attr_reader :document

    def initialize(*args)
      options  = args.last.is_a?(Hash) ? args.pop : {}
      html     = args.pop

      @name    = options[:name]
      @parent  = options[:parent] || self
      @opener  = options[:opener]
      @frames  = []
      @screen  = Screen.new(self)
      @history = History.new

      load(html, options) if html
    end

    def runtime
      @runtime ||= Johnson::Runtime.new.tap do |runtime|
        runtime['window']    = self
        runtime['document']  = document
        runtime['location']  = location
        runtime['navigator'] = navigator
        runtime['console']   = console
      end
    end

    def load(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      url     = uri?(args.first) || file?(args.first) ? args.shift.gsub(%r(^file://), '') : options[:url]
      html    = args.shift || (url ? open(url).read : raise("can't load without either html or url"))

      location.send(:set, url) if url
      load_document(html, url, options)
      load_scripts
      load_frames
      trigger_load_event
      Window::Timers::Task.run_all
    end

    def evaluate(script, file = nil, line = nil)
      runtime.evaluate(script, file, line, self, self)
    end

    def normalize_uri(uri)
      location.uri.normalize.merge(uri) rescue uri
    end

    def close
    end

    def location
      @location ||= Location.new(self)
    end

    def url
      location.href
    end

    def location=(uri)
      if location.href == uri
        location.reload
      elsif location.href == 'about:blank'
        location.assign(uri)
      else
        location.replace(uri)
      end
    end

    def navigator
      @navigator ||= Navigator.new
    end

    def getComputedStyle
      raise(NotImplementedError.new("not implemented: #{self.class.name}#getComputedStyle"))
    end

    def console
      @console ||= Console.new
    end

    def log(line)
      console.log(line)
    end

    def p(output)
      puts(output.inspect)
    end

    def puts(output)
      STDOUT.puts(output)
    end

    def print(output)
      STDOUT.print(output.to_s)
    end

    protected

      def load_document(html, url, options = {})
        flags = 1 << 1 | 1 << 2 | 1 << 3 | 1 << 4 | 1 << 5 | 1 << 6
        @document = Document.new(self, html, options.merge(:url => url))
      end

      def load_scripts
        document.getElementsByTagName('script').each do |script|
          process_script(script)
        end
      end

      def load_script(uri)
        script = open(normalize_uri(uri))
        script = script.string if script.respond_to?(:string)
        script = script.read   if script.respond_to?(:read)
        evaluate(script, uri)
      end

      def load_frames
        frames = %w(iframe frame).map do|tag_name|
          document.getElementsByTagName(tag_name)
        end
        frames.flatten.each { |frame| load_frame(frame) }
      end

      def load_frame(node)
        name = node.getAttribute('name')
        src  = node.getAttribute('src')

        node.contentWindow = Window.new(:parent => self, :name => name)
        node.contentWindow.location.href = normalize_uri(src) if src
      end

      def process_script(script)
        src = script.getAttribute('src')
        src && !src.empty? ? load_script(src) : evaluate(script.textContent)
      end

      def trigger_load_event
        event = document.createEvent('Events')
        event.initEvent('load')
        dispatchEvent(event)
      end

      def uri?(arg)
        uri = URI.parse(arg)
        %w(file http https).include?(uri.scheme)
      rescue
        false
      end

      def file?(arg)
        arg.to_s[0, 1] == '/'
      end
  end
end