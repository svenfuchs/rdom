LibXML::XML::Node.class_eval do
  undef :id, :type
  
  # we only want actual properties to be set as attributes because they would
  # show up in the markup otherwise
  alias :set_attribute :[]= if method_defined?(:[]=)
  def []=(name, value)
    if respond_to?(:"#{name}=")
      send(:"#{name}=", value)
    elsif property?(name)
      set_attribute(normalize_attribute_name(name), value.to_s)
    else 
      send(:"#{name}=", value)
    end
  end

  alias :get_attribute :[]
  def [](name)
    if respond_to?(name)
      send(name)
    elsif property?(name)
      get_attribute(normalize_attribute_name(name)) 
    end
  end
  
  protected
  
    def normalize_attribute_name(name)
      name = name.to_s
      name == 'className' ? 'class' : name
    end
  
  protected :children
end

module RDom
  module Properties
    def property?(name)
      property_names.include?(name.to_sym)
    end
    alias_method :js_property?, :property?

    def property_names
      @property_names ||= begin
        decorate! unless decorated? if respond_to?(:decorated?)
        consts = self.class.ancestors + (class << self; self; end).included_modules
        consts.uniq.map { |const| const::PROPERTIES rescue [] }.flatten.uniq
      end
    end
    
    # def respond_to?(name)
    #   property?(name) || define_property_accessor(name) || super
    # end

    def method_missing(name, *args, &block)
      if property?(name)
        self[name]
      elsif name.to_s =~ /^([\w]*)=$/ && property?($1)
        self[$1] = *args
      elsif define_property_accessor(name)
        self.send(name, *args)
      else
        super
      end
    end
    
    protected
    
      def define_property_accessor(name)
        if name.to_s =~ /^([\w]*)=$/
          (class << self; self; end).send(:attr_accessor, $1)
          true
        end
      end
  end
end