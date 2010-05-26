module RDom
  module DomAttributes
    def dom_attributes(*names)
      const_set(:HTML_ATTRIBUTES, names)
      properties(*names)
      include Module.new {
        extend(DomAttributeAccessors)
        dom_attribute_accessors(*names)
      }
    end

    module DomAttributeAccessors
      def dom_attribute_accessors(*names)
        names.each do |name|
          dom_attribute_reader(name)
          dom_attribute_writer(name)
        end
      end

      def dom_attribute_reader(name)
        define_method(name) do
          Attr.unserialize(name, getAttribute(name))
        end
      end

      def dom_attribute_writer(name)
        define_method(:"#{name}=") do |value|
          if Attr.boolean?(name)
            # JQuery sets selected to true/false in attributes.js #218
            # no idea where this stuff is defined in the dom specs ...
            value ? setAttribute(name, name) : removeAttribute(name)
          else
            setAttribute(name, value)
          end
        end
      end
    end
  end
end

