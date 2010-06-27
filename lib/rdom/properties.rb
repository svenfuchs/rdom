module RDom
  module Properties
    attr_accessor :property_names

    def properties(*names)
      @property_names ||= []
      @property_names += names.map { |name| name.to_sym }

      include InstanceMethods
      include Module.new {
        extend(Properties)
        property_accessors(*names)
      }
    end
    alias :property :properties

    private

      def property_accessors(*names)
        names.each { |name| define_property(name) unless method_defined?(name) }
      end

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
        property_modules.map { |m| m.property_names }.flatten.compact.uniq
      end

      private

        def property_modules
          @property_modules ||= begin
            meta_class = (class << self; self; end)
            consts = [meta_class] + ruby_class.ancestors + meta_class.included_modules
            consts.uniq.select { |const| const.method_defined?(:property_names) }
          end
        end
    end
  end
end

