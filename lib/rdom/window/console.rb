module RDom
  class Window
    class Console
      def log(*args)
        @log ||= []
        args.empty? ? @log : @log << args
      end

      alias_method :debug, :log
      alias_method :info,  :log
      alias_method :warn,  :log
      alias_method :error, :log
      
      def print
        log.each do |line|
          puts line.map { |arg| arg.to_s }.join(', ')
        end
      end
      
      def last_item
        log.last.last
      end
    end
  end
end