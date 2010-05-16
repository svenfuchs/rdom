LibXML::XML::Node.class_eval do
  alias :libxml_read_attribute :[]
  alias :libxml_write_attribute :[]=
  alias :libxml_name :name

  undef :id, :type, :[], :[]=, :name
  
  # we only want actual properties to be set as attributes because they would
  # show up in the markup otherwise
end

module RDom
  module Properties
    def decorate!
      super
      define_property_accessors!
    end
    
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
    
      def define_property_accessors!
        property_names.each do |name|
          (class << self; self; end).class_eval do
            define_method(name) { libxml_read_attribute(name.to_s) || '' } unless method_defined?(name)
            define_method(:"#{name}=") { |value| libxml_write_attribute(name.to_s, value.to_s) } unless method_defined?(:"#{name}=")
          end if respond_to?(:libxml_read_attribute)
        end
      end
  end
end