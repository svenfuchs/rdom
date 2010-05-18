LibXML::XML::Node.class_eval do
  alias :libxml_read_attribute :[]
  alias :libxml_write_attribute :[]=
  alias :libxml_name :name

  undef :[], :[]=, :name
end

module RDom
  module Properties
    def properties(*names)
      const_set(:PROPERTIES, names)
      define_property_accessors!
      include InstanceMethods
    end
    
    def define_property_accessors!
      self::PROPERTIES.each do |name|
        next if method_defined?(name) || method_defined?(:"#{name}=")
        define_method(name) { libxml_read_attribute(name.to_s) || '' }
        define_method(:"#{name}=") { |value| libxml_write_attribute(name.to_s, value.to_s) }
      end
    end
    
    module InstanceMethods
      def property?(name)
        property_names.include?(name.to_sym)
      end
      alias_method :js_property?, :property?
    
      protected
    
        def property_names
          @property_names ||= begin
            consts = self.class.ancestors + (class << self; self; end).included_modules
            consts.uniq.map { |const| const.const_defined?(:PROPERTIES) ? const::PROPERTIES : [] }.flatten.uniq
          end
        end
    end
  end
end

