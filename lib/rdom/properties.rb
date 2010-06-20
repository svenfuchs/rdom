module RDom
  module Properties
    module InstanceMethods
      def property?(name)
        property_names.include?(name.to_sym)
      end
      alias_method :js_property?, :property?

      def property_names
        @property_names ||= property_modules.map do |const|
          const.property_names
        end.flatten.compact.uniq
      end

      protected

        def property_modules
          meta_class = (class << self; self; end)
          consts = [meta_class] + ruby_class.ancestors + meta_class.included_modules
          consts.uniq.select { |const| const.method_defined?(:property_names) }
        end
    end

    attr_accessor :property_names

    def properties(*names)
      self.property_names ||= []
      self.property_names += names.map { |name| name.to_sym }
      include InstanceMethods
    end
  end
end

