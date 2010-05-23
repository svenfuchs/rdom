module RDom
  class Event
    class Exception < StandardError
      NOT_SUPPORTED_ERR          = 0
      UNSPECIFIED_EVENT_TYPE_ERR = 1
      UNDEFINED_EVENT_ERR        = 2
      INVALID_EVENT_KIND_ERR     = 3

      attr_accessor :code

      def initialize code, message = nil
        @code = code
        super(message)
      end
    end
  end
end