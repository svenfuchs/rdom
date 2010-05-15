# Johnson regards anything that is defined as an instance variable as a js
# property. This seems somewhat dangerous, we want more control here.

module Johnson
  module TraceMonkey
    module JSLandProxy
      def self.js_property?(target, name)
        # (target.send(:instance_variable_defined?, "@#{name}") rescue false) ||
        target.respond_to?(:js_property?) && target.js_property?(name)
      end
    end
  end
end