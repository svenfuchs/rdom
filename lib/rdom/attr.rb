require 'core_ext/object/blank'

module RDom
  module Attr
    BOOLEAN_ATTRIBUTES  = [ :compact, :checked, :declare, :readOnly, :disabled,
                            :selected, :defer, :ismap, :noHref, :noShade,
                            :noWrap, :multiple, :noResize ]

    NUMERIC_ATTRIBUTES  = [ :cellIndex, :cols, :colSpan, :height, :hspace,
                            :index, :length, :maxLength, :rowIndex, :rows,
                            :rowSpan, :sectionRowIndex, :selectedIndex, :size,
                            :span, :start, :tabIndex, :vspace, :width ]

    READONLY_ATTRIBUTES = [ :anchors, :applets, :areas, :cellIndex, :cells,
                            :contentDocument, :ction, :options, :domain,
                            :elements, :form, :forms, :images, :index, :length,
                            :links, :referrer, :rowIndex, :rows,
                            :sectionRowIndex, :tBodies, :text, :type, :URL ]

    class << self
      def boolean?(name)
        BOOLEAN_ATTRIBUTES.include?(name.to_sym)
      end

      def numeric?(name)
        NUMERIC_ATTRIBUTES.include?(name.to_sym)
      end

      def readonly?(name)
        READONLY_ATTRIBUTES.include?(name.to_sym)
      end

      # http://reference.sitepoint.com/javascript/Element/setAttribute
      # In all browsers an attribute which evaluates to a boolean (such as
      # disabled) can only be set to true — setting it to false has no effect.
      # This is correct behavior, and is because such attributes should only
      # have one possible value (ie. disabled="disabled")
      def serialize(name, value)
        value = name if boolean?(name)
        value.to_s
      end

      # http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-642250288
      # The return value of an attribute that is unspecified and does not have a
      # default value is the empty string if the return type is a DOMString,
      # false if the return type is a boolean and 0 if the return type is a
      # number.
      def unserialize(name, value)
        if boolean?(name)
          !value.blank?
        elsif numeric?(name)
          value.to_i
        else
          value.to_s
        end
      end
    end

    properties :name, :value, :nodeType, :nodeValue, :specified, :ownerElement
    
    attr_accessor :specified

    def name
      node_name
    end

    def value
      Attr.unserialize(name, nokogiri_value)
    end

    def value=(value)
      self.specified = false
      super(Attr.serialize(name, value))
    end

    def nodeType
      LibXML::XML::Node::ATTRIBUTE_NODE
    end

    def nodeValue
      value
    end

    def specified
      defined?(@specified) ? @specified : @specified = true
    end
    attr_writer :specified

    def ownerElement
      parent
    end

    def parentNode
      nil
    end

    def previousSibling
      nil
    end

    def nextSibling
      nil
    end
  end
end