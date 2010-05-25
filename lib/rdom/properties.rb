module RDom
  module Properties
    module InstanceMethods
      def property?(name)
        property_names.include?(name.to_sym)
      end
      alias_method :js_property?, :property?

      protected

        def property_names
          @property_names ||= property_modules.map do |const|
            const.property_names
          end.flatten.compact.uniq
        end

        def property_modules
          consts = ruby_class.ancestors + (class << self; self; end).included_modules
          consts.uniq.select { |const| const.method_defined?(:property_names) }
        end
    end

    attr_accessor :property_names

    def html_attributes(*names)
      const_set(:HTML_ATTRIBUTES, names)
      properties(*names)
      html_attribute_accessors(*names)
    end

    def properties(*names)
      self.property_names ||= []
      self.property_names += names
      include InstanceMethods
    end

    protected

      def html_attribute_accessors(*names)
        names.each do |name|
          html_attribute_reader(name)
          html_attribute_writer(name)
        end
      end

      def html_attribute_reader(name)
        define_method(name) do
          Attr.unserialize(name, getAttribute(name))
        end unless method_defined?(name)
      end

      def html_attribute_writer(name)
        define_method(:"#{name}=") do |value|
          if Attr.boolean?(name)
            value ? setAttribute(name, name) : removeAttribute(name)
          else
            setAttribute(name, value)
          end
        end unless method_defined?(:"#{name}=")
      end
  end
end

