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
      define_html_attribute_accessors!
    end

    def properties(*names)
      self.property_names ||= []
      self.property_names += names
      include InstanceMethods
    end

    protected

      def define_html_attribute_accessors!
        self::HTML_ATTRIBUTES.each do |name|
          next if method_defined?(name) || method_defined?(:"#{name}=")
          define_method(name) { Attr.unserialize(name, getAttribute(name)) }
          define_method(:"#{name}=") { |value| setAttribute(name, value) }
        end
      end
  end
end

