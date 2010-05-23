module RDom
  module Properties
    attr_accessor :property_names

    def dom_attributes(*names)
      properties(*names)
      define_dom_attribute_accessors!
    end

    def properties(*names)
      self.property_names ||= []
      self.property_names += names
      include InstanceMethods
    end

    def define_dom_attribute_accessors!
      property_names.each do |name|
        next if method_defined?(name) || method_defined?(:"#{name}=")
        define_method(name) { getAttribute(name) || '' }
        define_method(:"#{name}=") { |value| setAttribute(name, value) }
      end
    end

    module InstanceMethods
      def property?(name)
        property_names.include?(name.to_sym)
      end
      alias_method :js_property?, :property?

      protected

        def property_names
          property_names ||= begin
            consts = self.class.ancestors + (class << self; self; end).included_modules
            consts.uniq.map { |const| const.respond_to?(:property_names) ? const.property_names : [] }.flatten.uniq
          end
        end
    end
  end
end

