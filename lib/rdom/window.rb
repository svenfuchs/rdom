require 'open-uri'
# require 'johnson/tracemonkey'
# require 'johnson/js_land_proxy_patch'
require 'v8'

STDOUT.sync = true
require 'therubyracer/rdom_access'


module RDom
  class Window
    autoload :Console,   'rdom/window/console.rb'
    autoload :Frame,     'rdom/window/frame.rb'
    autoload :History,   'rdom/window/history.rb'
    autoload :Navigator, 'rdom/window/navigator.rb'
    autoload :Screen,    'rdom/window/screen.rb'
    autoload :Timers,    'rdom/window/timers.rb'

    include Event::Target, Window::Timers

    properties :window, :document, :screen, :location, :navigator, :url, :console,
               :parent, :name, :document, :defaultStatus, :history, :opener, :frames,
               :innerHeight, :innerWidth, :outerHeight, :outerWidth, :screenX, :screenY,
               :pageXOffset, :pageYOffset, :screenLeft, :screenTop

    def initialize(*args)
      options  = args.last.is_a?(Hash) ? args.pop : {}
      html     = args.pop

      self.name    = options[:name]
      self.parent  = options[:parent] || self
      self.opener  = options[:opener]
      self.frames  = []
      self.screen  = Screen.new(self)
      self.history = History.new
      self.window = self

      load(html, options) if html
    end

    # def runtime
    #   @runtime ||= V8::Context.new do |runtime|
    #     runtime['window']   = self
    #     runtime['document'] = document
    #   end
    # end

    def runtime
      @runtime ||= V8::Context.new(:with => self)
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
      runtime.eval(script, file) # , file, line, self, self
    end
    alias :eval :evaluate

    def normalize_uri(uri)
      location.uri.normalize.merge(uri) rescue uri
    end

    def close
    end

    def url
      location.href
    end

    def location
      @location ||= Location.new(self)
    end

    def location=(uri)
      if Location === uri
        @location = uri
      elsif location.href == uri
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
        self.document = Document.new(self, html, options.merge(:url => url))
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
        src && !src.empty? ? load_script(src) : evaluate(script.textContent, src)
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