module Johnson
  module TraceMonkey
    module JSLandProxy
      # Johnson does not allow to pass a function to Ruby land. Let's change that.
      # Maybe it's possible to maintain the previous behaviour by checking the
      # target method's arity?
      def self.send_with_possible_block(target, symbol, args)
        # block = args.pop if args.last.is_a?(RubyLandProxy) && args.last.function?
        # target.__send__(symbol, *args, &block)
        target.__send__(symbol, *args)
      end

      # Johnson regards anything that is defined as an instance variable as a js
      # property. This seems somewhat dangerous, we want more control here.
      def self.js_property?(target, name)
        # (target.send(:instance_variable_defined?, "@#{name}") rescue false) ||
        target.respond_to?(:js_property?) && target.js_property?(name)
      end
    end
  end
end