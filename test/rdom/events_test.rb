require File.expand_path('../../test_helper', __FILE__)

class EventsTest < Test::Unit::TestCase
  attr_reader :doc, :body, :foo, :event

  def setup
    html   = '<html><body><a id="foo" href="#"></a></body></html>'
    @doc   = RDom::Document.parse(html)
    @foo   = doc.getElementById('foo')
    @body  = doc.getElementsByTagName('body').first
    @event = doc.createEvent('MouseEvents')
  end

  # Each event has an EventTarget toward which the event is directed by the DOM
  # implementation. This EventTarget is specified in the Event's target
  # attribute.
  test "event target is the original target node, currentTarget is the currently processing node" do
    targets, current_targets = [], []
    listener = lambda do |event|
      targets << event.target
      current_targets << event.currentTarget
    end

    doc.addEventListener('click', listener)
    foo.addEventListener('click', listener)

    event.initEvent('click')
    foo.dispatchEvent(event)

    assert_equal [foo, foo], targets
    assert_equal [foo, doc], current_targets
  end

  # When the event reaches the target, any event listeners registered on the
  # EventTarget are triggered.
  #
  # A capturing EventListener will not be triggered by events dispatched
  # directly to the EventTarget upon which it is registered.
  test "event triggers multiple listeners on multiple targets during capturing, capturing not triggered on dispatching node" do
    triggered = []
    doc.addEventListener('click', lambda { triggered << 'doc:capture' }, true)
    foo.addEventListener('click', lambda { triggered << 'foo:capture' }, true)
    foo.addEventListener('click', lambda { triggered << 'foo:bubble' })
    doc.addEventListener('click', lambda { triggered << 'doc:bubble' })

    event.initEvent('click')
    foo.dispatchEvent(event)

    assert_equal %w(doc:capture foo:bubble doc:bubble), triggered
  end

  # If neither event capture or event bubbling are in use for that particular
  # event, the event flow process will complete after all listeners have been
  # triggered.
  test 'an event initialized as not bubbling does not bubble' do
    triggered = []
    foo.addEventListener('click', lambda { triggered << 'foo:bubble' }, false)
    doc.addEventListener('click', lambda { triggered << 'doc:bubble' }, false)

    event.initEvent('click', false) # doesn't bubble
    foo.dispatchEvent(event)

    assert_equal %w(foo:bubble), triggered
  end

  # Any exceptions thrown inside an EventListener will not stop propagation of
  # the event. It will continue processing any additional EventListener in the
  # described manner.

  # It is expected that actions taken by EventListeners may cause additional
  # events to fire. Additional events should be handled in a synchronous manner
  # and may cause reentrancy into the event model.
  test 'events can fire additional events and are handled in a synchronous manner' do
    triggered = []

    over = doc.createEvent('MouseEvents')
    over.initEvent('mouseOver')

    out = doc.createEvent('MouseEvents')
    out.initEvent('mouseOut')

    foo.addEventListener('mouseOver', lambda { |event| triggered << event; foo.dispatchEvent(out) })
    foo.addEventListener('mouseOut',  lambda { |event| triggered << event })

    foo.dispatchEvent(over)
    assert_equal [over, out], triggered
  end

  # If an EventListener is added to an EventTarget while it is processing an
  # event, it will not be triggered by the current actions but may be triggered
  # during a later stage of event flow, such as the bubbling phase.
  test 'listeners registered during dispatch are triggered when registered to a node dispatched later on' do
    triggered = []

    listener = lambda { |event| 
      triggered << 'doc:capturing'
      doc.addEventListener('click', lambda { |event| triggered << 'does not happen' }, true)
      doc.addEventListener('click', lambda { |event| triggered << 'doc:bubbling' }) 
    }

    doc.addEventListener('click', listener, true)
    event.initEvent('click')
    foo.dispatchEvent(event)

    assert_equal %w(doc:capturing doc:bubbling), triggered
  end

  # If multiple identical EventListeners are registered on the same EventTarget
  # with the same parameters the duplicate instances are discarded. They do not
  # cause the EventListener to be called twice
  test 'a listener registered to the same target multiple times is only called once' do
    triggered = []
    listener = lambda { |event| triggered << event.type }

    foo.addEventListener('click', listener)
    foo.addEventListener('click', listener)

    event.initEvent('click')
    foo.dispatchEvent(event)
    
    assert_equal %w(click), triggered
  end

  # The chain of EventTargets from the top of the tree to the event's target is
  # determined before the initial dispatch of the event. If modifications occur
  # to the tree during event processing, event flow will proceed based on the
  # initial state of the tree.
  test "event targets for capturing are determined before the initial dispatch" do
    triggered = []
    listener = lambda do |event|
      triggered << event.currentTarget.nodeName
      div = doc.createElement('div')
      body.appendChild(div)
      div.appendChild(foo)
      div.addEventListener('click', lambda { triggered << event.currentTarget.nodeName }, true)
    end
    
    body.addEventListener('click', listener, true)
    event.initEvent('click')
    foo.dispatchEvent(event)
    
    assert_equal %w(body), triggered
  end

  # The chain of EventTargets from the event target to the top of the tree is
  # determined before the initial dispatch of the event. If modifications occur
  # to the tree during event processing, event flow will proceed based on the
  # initial state of the tree.
  test "event targets for bubbling are determined before the initial dispatch" do
    triggered = []
    listener = lambda do |event|
      triggered << event.currentTarget.nodeName
      div = doc.createElement('div')
      body.appendChild(div)
      div.appendChild(foo)
      div.addEventListener('click', lambda { triggered << event.currentTarget.nodeName })
    end
    
    body.addEventListener('click', listener)
    event.initEvent('click')
    foo.dispatchEvent(event)
    
    assert_equal %w(body), triggered
  end

  # Both capturing and bubbling:
  # Any event handler may choose to prevent further event propagation by
  # calling the stopPropagation method of the Event interface. This will
  # prevent further dispatch of the event, although additional EventListeners
  # registered at the same hierarchy level will still receive the event.
  test 'stopping event propagation during capturing phase' do
    triggered = []
    doc.addEventListener('click', lambda { triggered << 'doc:capture'; event.stopPropagation }, true)
    foo.addEventListener('click', lambda { triggered << 'body:capture' }, true)
    foo.addEventListener('click', lambda { triggered << 'body:bubble' })
    doc.addEventListener('click', lambda { triggered << 'doc:bubble' })

    event.initEvent('click')
    foo.dispatchEvent(event)

    assert_equal %w(doc:capture), triggered
  end
  
  test 'stopping event propagation during bubbling phase' do
    triggered = []
    doc.addEventListener('click', lambda { triggered << 'doc:capture' }, true)
    foo.addEventListener('click', lambda { triggered << 'body:bubble'; event.stopPropagation })
    doc.addEventListener('click', lambda { triggered << 'doc:bubble' })

    event.initEvent('click')
    foo.dispatchEvent(event)

    assert_equal %w(doc:capture body:bubble), triggered
  end

  # When a Node is copied using the cloneNode method the EventListeners attached
  # to the source Node are not attached to the copied Node.
  test 'cloneNode does not clone any attached listeners' do
    triggered = []
    foo.addEventListener('click', lambda { |event| triggered << 'does not happen' })
    
    bar = foo.cloneNode(true)
    foo.parentNode.appendChild(bar)

    event.initEvent('click')
    bar.dispatchEvent(event)

    assert triggered.empty?
  end

  # The return value of dispatchEvent indicates whether any of the listeners
  # which handled the event called preventDefault. If preventDefault was called
  # the value is false, else the value is true.
  test 'dispatchEvent returns true if event.preventDefault was called' do
    event = doc.createEvent('MouseEvents')
    event.initEvent('click', false)
    
    foo.addEventListener('click', lambda { })
    assert !foo.dispatchEvent(event)

    event = doc.createEvent('MouseEvents')
    event.initEvent('click', false)

    body.addEventListener('click', lambda { |event| event.preventDefault })
    assert body.dispatchEvent(event)
  end

  # TODO

  # Some events are specified as cancelable. For these events, the DOM
  # implementation generally has a default action associated with the event.
  # (...) Listeners then have the option of canceling the implementation's
  # default action or allowing the default action to proceed. In the case of the
  # hyperlink in the browser, canceling the action would have the result of not
  # activating the hyperlink. Cancelation is accomplished by calling the Event's
  # preventDefault method. If one or more EventListeners call preventDefault
  # during any phase of event flow the default action will be canceled.

  # In order to achieve compatibility with HTML 4.0, implementors may view the
  # setting of attributes which represent event handlers as the creation and
  # registration of an EventListener on the EventTarget.
  # If the attribute representing the event listener is changed, this may be
  # viewed as the removal of the previously registered EventListener and the
  # registration of a new one.
  
  # # Used to indicate whether or not an event is a bubbling event. If the
  # # event can bubble the value is true, else the value is false.
  # attr_accessor :bubbles
  # 
  # # Used to indicate whether or not an event can have its default action
  # # prevented. If the default action can be prevented the value is true,
  # # else the value is false.
  # attr_accessor :cancelable
  # 
  # # Used to indicate the EventTarget to which the event was originally
  # # dispatched.
  # attr_accessor :target
  # 
  # # Used to indicate the EventTarget whose EventListeners are currently
  # # being processed. This is particularly useful during capturing and
  # # bubbling.
  # attr_accessor :currentTarget
  # 
  # # Used to indicate which phase of event flow is currently being evaluated.
  # attr_accessor :eventPhase
  # 
  # # Used to specify the time (in milliseconds relative to the epoch) at
  # # which the event was created. Due to the fact that some systems may not
  # # provide this information the value of timeStamp may be not available for
  # # all events. When not available, a value of 0 will be returned.
  # attr_accessor :timeStamp
  # 
  # # The name of the event (case-insensitive). The name must be an XML name.
  # attr_accessor :type
end