module RDom
  class Window
    module Timers
      class Task
        class << self
          def run_all
            count = 0
            until tasks.empty?
              handle, task = tasks.to_a.last
              remove(handle)
              task.process
              return if (count += 1) > 100
            end
          end

          def schedule(handler, delay, *args)
            handle = next_handle
            tasks[handle] = new(handler, delay, args)
            handle
          end
          
          def remove(handle)
            tasks.delete(handle)
          end
        
          def next_handle
            @@next_handle ||= 0
            @@next_handle =+ 1
          end
        
          def tasks
            @@tasks ||= {}
          end
        end
        
        attr_reader :handler, :args, :run_at, :thread
      
        def initialize(handler, delay, args)
          @handler, @args = handler, args
          @run_at = Time.now + delay.to_f / 1000
          # schedule! # gives: RuntimeError: Johnson is not thread safe ...
        end
        
        def schedule!
          @thread = Thread.new do
            sleep(0.1) until due?
            process
          end
          thread.join
        end
        
        def due?
          Time.now > run_at
        end
        
        def process
          handler.call(*args)
        end
      end
      
      def setTimeout(handler, delay, *args)
        Window::Timers::Task.schedule(handler, delay, *args)
      end
      
      def clearTimeout(handle)
        Window::Timers::Task.remove(handle)
      end
      
      def setInterval(handler, timeout, *args)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#setInterval"))
      end
      
      def clearInterval(handle)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#clearInterval"))
      end
    end
  end
end