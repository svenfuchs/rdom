module RDom
  class Event
    autoload :Exception, 'rdom/event/exception'
    autoload :Target,    'rdom/event/target'
    autoload :Mouse,     'rdom/event/mouse'
    autoload :Mutation,  'rdom/event/mutation'
    autoload :Ui,        'rdom/event/ui'

    include Decoration

    properties :bubbles, :cancelable, :target, :currentTarget, :eventPhase,
               :timeStamp, :type

    # Used to indicate whether or not an event is a bubbling event. If the
    # event can bubble the value is true, else the value is false.
    attr_accessor :bubbles

    # Used to indicate whether or not an event can have its default action
    # prevented. If the default action can be prevented the value is true,
    # else the value is false.
    attr_accessor :cancelable

    # Used to indicate the EventTarget to which the event was originally
    # dispatched.
    attr_accessor :target

    # Used to indicate the EventTarget whose EventListeners are currently
    # being processed. This is particularly useful during capturing and
    # bubbling.
    attr_accessor :currentTarget

    # Used to indicate which phase of event flow is currently being evaluated.
    attr_accessor :eventPhase

    # Used to specify the time (in milliseconds relative to the epoch) at
    # which the event was created. Due to the fact that some systems may not
    # provide this information the value of timeStamp may be not available for
    # all events. When not available, a value of 0 will be returned.
    attr_accessor :timeStamp

    # The name of the event (case-insensitive). The name must be an XML name.
    attr_accessor :type

    TYPES = %w(Events UIEvents MouseEvents HTMLEvents MutationEvents)

    CAPTURING_PHASE = :capturing
    AT_TARGET       = :at_target
    BUBBLING_PHASE  = :bubbling

    # internal use, how to other UAs implement these?
    attr_reader :kind, :__cancelled, :__propagation_stopped

    def initialize(kind)
      @kind = kind
      validate!
    end

    def initEvent(type, bubbles = true, cancelable = true)
      @type       = type
      @bubbles    = bubbles
      @cancelable = cancelable
      self
    end

    def stopPropagation
      if cancelable
        @__propagation_stopped = true;
        @bubbles = false;
      end
    end

    def preventDefault
      @__cancelled = true
    end

    protected

      def validate!
        if kind.nil? || kind.empty?
          raise EventException.new(EventException::INVALID_EVENT_KIND_ERR)
        elsif !TYPES.include?(kind)
          raise EventException.new(EventException::NOT_SUPPORTED_ERR)
        end
      end
  end
end