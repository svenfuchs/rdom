module RDom
  module Properties
    attr_accessor :property_names

    def properties(*names)
      @property_names ||= []
      @property_names += names.map { |name| name.to_sym }
      include InstanceMethods
      names.each { |name| define_property(name) unless method_defined?(name) }
    end
    alias :property :properties

    private

      def define_property(name)
        define_method(name) { || properties[name] }
        define_method(:"#{name}=") { |value| properties[name] = value }
      end

    module InstanceMethods
      def properties
        @properties ||= {}
      end

      def property?(name)
        property_names.include?(name.to_sym)
      end
      alias_method :js_property?, :property?

      def property_names
        @property_names ||= property_modules.map do |const|
          const.property_names
        end.flatten.compact.uniq
      end

      private

        def property_modules
          meta_class = (class << self; self; end)
          consts = [meta_class] + ruby_class.ancestors + meta_class.included_modules
          consts.uniq.select { |const| const.method_defined?(:property_names) }
        end
    end
  end
end

