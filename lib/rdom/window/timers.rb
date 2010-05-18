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
      
      # This method calls the function once after a specified number of
      # milliseconds elapses, until canceled by a call to clearTimeout. The
      # methods returns a timerID which may be used in a subsequent call to
      # clearTimeout to cancel the interval.
      def setTimeout(handler, delay, *args)
        Window::Timers::Task.schedule(handler, delay, *args)
      end
      
      # Cancels a timeout that was set with the setTimeout method.
      def clearTimeout(handle)
        Window::Timers::Task.remove(handle)
      end
      
      # This method calls the function every time a specified number of
      # milliseconds elapses, until canceled by a call to clearInterval. The
      # methods returns an intervalID which may be used in a subsequent call
      # to clearInterval to cancel the interval.
      def setInterval(handler, timeout, *args)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#setInterval"))
      end
      
      # Cancels an interval that was set with the setTimeout method.
      def clearInterval(handle)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#clearInterval"))
      end
    end
  end
end