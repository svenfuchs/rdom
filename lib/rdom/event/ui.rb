module RDom
  class Event
    class Ui < Event
      attr_accessor :view, :detail
    
      def initUIEvent(type, canBubble, cancelable, view, detail)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#initUIEvent"))
      end
    
      def initUIEventNS(namespaceURI, type, canBubble, cancelable, view, detail)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#initUIEventNS"))
      end
    end
  end
end