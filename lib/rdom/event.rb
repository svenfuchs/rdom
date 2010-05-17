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
    
    attr_accessor *PROPERTIES

    TYPES = %w(Events UIEvents MouseEvents HTMLEvents MutationEvents)

    CAPTURING_PHASE = :capturing
    AT_TARGET       = :at_target
    BUBBLING_PHASE  = :bubbling

    # internal use, how to other UAs implement these?
    attr_reader :__cancelled, :__propagation_stopped
                  
    def initialize(kind)
      raise EventException.new(EventException::NOT_SUPPORTED_ERR) unless TYPES.include?(kind)
      @kind = kind || raise('implementation or platform exception') # TODO what's a more sensible exception here?
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
  end
end