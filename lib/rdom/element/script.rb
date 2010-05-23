module RDom
  module Element
    module Script
      class << self
        def process(node)
          node.ownerDocument.defaultView.send(:process_script, node) if node.ownerDocument.defaultView
        end
      end

      dom_attributes :text, :htmlFor, :event, :charset, :defer, :src, :type

      # def appendChild(node)
      #   super
      #   Element::Script.process(node)
      # end
    end
  end
end