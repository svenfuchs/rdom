module RDom
  module Attr
    properties :name, :value

    # TODO does not work with Properties unconditionally uses libxml_read_attribute
    def name
      super
    end

    def value
      super
    end
  end
end