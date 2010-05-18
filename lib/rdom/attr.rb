module RDom
  module Attr
    properties :name, :value, :nodeValue

    # TODO does not work with Properties unconditionally uses libxml_read_attribute
    def name
      super
    end

    def value
      super
    end

    def nodeValue
      value
    end
  end
end