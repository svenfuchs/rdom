require File.expand_path('../../test_helper', __FILE__)

class EventsTest < Test::Unit::TestCase
  attr_reader :window, :document

  def setup
    @window = RDom::Window.new('<html><body><a id="foo" href="#"></a></body></html>')
    @document = window.document
  end

  # DOM-Level-2-Events
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Events-20001113/events.html

  # Each event has an EventTarget toward which the event is directed by the DOM
  # implementation. This EventTarget is specified in the Event's target
  # attribute.
  test "ruby: event target is the original target node, currentTarget is the currently processing node", :ruby do
    foo = document.getElementById('foo')
    targets, current_targets = [], []
    listener = lambda do |event|
      targets << event.target.nodeName
      current_targets << event.currentTarget.nodeName
    end

    document.addEventListener('click', listener)
    foo.addEventListener('click', listener)

    event = document.createEvent('MouseEvents').initEvent('click')
    foo.dispatchEvent(event)

    assert_equal %w(A A), targets
    assert_equal %w(A #document), current_targets
  end

  test "js: event target is the original target node, currentTarget is the currently processing node", :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      targets = [], current_targets = []
      listener = {
        handleEvent: function(event) {
          targets.push(event.target.nodeName)
          current_targets.push(event.currentTarget.nodeName)
          return true
        }
      }

      document.addEventListener('click', listener)
      foo.addEventListener('click', listener)

      event = document.createEvent('MouseEvents').initEvent('click')
      foo.dispatchEvent(event)
    js

    assert_equal %w(A A), window.evaluate("targets").to_a
    assert_equal %w(A #document), window.evaluate("current_targets").to_a
  end

  # When the event reaches the target, any event listeners registered on the
  # EventTarget are triggered.
  #
  # A capturing EventListener will not be triggered by events dispatched
  # directly to the EventTarget upon which it is registered.
  test "ruby: event triggers multiple listeners on multiple targets during capturing, capturing not triggered on dispatching node", :ruby do
    foo = document.getElementById('foo')
    triggered = []

    document.addEventListener('click', lambda { triggered << 'doc:capture' }, true)
    document.addEventListener('click', lambda { triggered << 'doc:bubble' })
    foo.addEventListener('click', lambda { triggered << 'foo:capture' }, true)
    foo.addEventListener('click', lambda { triggered << 'foo:bubble' })

    event = document.createEvent('MouseEvents').initEvent('click')
    foo.dispatchEvent(event)

    assert_equal %w(doc:capture foo:bubble doc:bubble), triggered
  end

  test "js: event triggers multiple listeners on multiple targets during capturing, capturing not triggered on dispatching node", :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []
      listener = function(msg) {
        return { handleEvent: function(event) { triggered.push(msg); return true } };
      }

      document.addEventListener('click', listener('doc:capture'), true)
      document.addEventListener('click', listener('doc:bubble'))
      foo.addEventListener('click', listener('foo:capture'), true)
      foo.addEventListener('click', listener('foo:bubble'))

      event = document.createEvent('MouseEvents').initEvent('click')
      foo.dispatchEvent(event)
    js

    assert_equal %w(doc:capture foo:bubble doc:bubble), window.evaluate("triggered").to_a
  end

  # If neither event capture or event bubbling are in use for that particular
  # event, the event flow process will complete after all listeners have been
  # triggered.
  test 'ruby: an event initialized as not bubbling does not bubble', :ruby do
    foo = document.getElementById('foo')
    triggered = []

    foo.addEventListener('click', lambda { triggered << 'foo:bubble' }, false)
    document.addEventListener('click', lambda { triggered << 'doc:bubble' }, false)

    event = document.createEvent('MouseEvents').initEvent('click', false) # doesn't bubble
    foo.dispatchEvent(event)

    assert_equal %w(foo:bubble), triggered
  end

  test 'js: an event initialized as not bubbling does not bubble', :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []
      listener = function(msg) {
        return { handleEvent: function(event) { triggered.push(msg); return true } };
      }

      foo.addEventListener('click', listener('foo:bubble'), false)
      document.addEventListener('click', listener('doc:bubble'), false)

      event = document.createEvent('MouseEvents').initEvent('click', false)
      foo.dispatchEvent(event)
    js

    assert_equal %w(foo:bubble), window.evaluate("triggered").to_a
  end

  # Any exceptions thrown inside an EventListener will not stop propagation of
  # the event. It will continue processing any additional EventListener in the
  # described manner.

  # TODO

  # It is expected that actions taken by EventListeners may cause additional
  # events to fire. Additional events should be handled in a synchronous manner
  # and may cause reentrancy into the event model.
  test 'ruby: events can fire additional events and are handled in a synchronous manner', :ruby do
    foo = document.getElementById('foo')
    triggered = []

    over = document.createEvent('MouseEvents').initEvent('mouseOver')
    out  = document.createEvent('MouseEvents').initEvent('mouseOut')

    foo.addEventListener('mouseOver', lambda { |event| triggered << event.type; foo.dispatchEvent(out) })
    foo.addEventListener('mouseOut',  lambda { |event| triggered << event.type })

    foo.dispatchEvent(over)
    assert_equal %w(mouseOver mouseOut), triggered
  end

  test 'js: events can fire additional events and are handled in a synchronous manner', :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []

      over = document.createEvent('MouseEvents').initEvent('mouseOver')
      out  = document.createEvent('MouseEvents').initEvent('mouseOut')

      foo.addEventListener('mouseOver', {
        handleEvent: function(event) {
          triggered.push(event.type)
          foo.dispatchEvent(out)
          return true
        }
      })
      foo.addEventListener('mouseOut', {
        handleEvent: function(event) {
          triggered.push(event.type);
          return true
        }
      })
      foo.dispatchEvent(over)
    js
    assert_equal %w(mouseOver mouseOut), window.evaluate("triggered").to_a
  end

  # If an EventListener is added to an EventTarget while it is processing an
  # event, it will not be triggered by the current actions but may be triggered
  # during a later stage of event flow, such as the bubbling phase.
  test 'ruby: listeners registered during dispatch are triggered when registered to a node dispatched later on', :ruby do
    foo = document.getElementById('foo')
    triggered = []

    listener = lambda { |event|
      triggered << 'doc:capturing'
      document.addEventListener('click', lambda { |event| triggered << 'does not happen' }, true)
      document.addEventListener('click', lambda { |event| triggered << 'doc:bubbling' })
    }

    document.addEventListener('click', listener, true)
    event = document.createEvent('MouseEvents').initEvent('click')
    foo.dispatchEvent(event)

    assert_equal %w(doc:capturing doc:bubbling), triggered
  end

  test 'js: listeners registered during dispatch are triggered when registered to a node dispatched later on', :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []
      listener = function(msg) {
        return { handleEvent: function(event) { triggered.push(msg); return true } };
      }

      document.addEventListener('click', {
        handleEvent: function(event) {
          triggered.push('doc:capturing')
          document.addEventListener('click', listener('does not happen'), true)
          document.addEventListener('click', listener('doc:bubbling'))
          return true
        }
      }, true)
      event = document.createEvent('MouseEvents').initEvent('click')
      foo.dispatchEvent(event)
    js

    assert_equal %w(doc:capturing doc:bubbling), window.evaluate("triggered").to_a
  end

  # If multiple identical EventListeners are registered on the same EventTarget
  # with the same parameters the duplicate instances are discarded. They do not
  # cause the EventListener to be called twice
  test 'ruby: a listener registered to the same target multiple times is only called once', :ruby do
    foo = document.getElementById('foo')
    triggered = []
    listener = lambda { |event| triggered << event.type }

    foo.addEventListener('click', listener)
    foo.addEventListener('click', listener)

    event = document.createEvent('MouseEvents').initEvent('click')
    foo.dispatchEvent(event)

    assert_equal %w(click), triggered
  end

  test 'js: a listener registered to the same target multiple times is only called once', :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []
      listener = { handleEvent: function(event) { triggered.push(event.type); return true } }

      foo.addEventListener('click', listener)
      foo.addEventListener('click', listener)

      event = document.createEvent('MouseEvents').initEvent('click')
      foo.dispatchEvent(event)
    js

    assert_equal %w(click), window.evaluate("triggered").to_a
  end

  # The chain of EventTargets from the top of the tree to the event's target is
  # determined before the initial dispatch of the event. If modifications occur
  # to the tree during event processing, event flow will proceed based on the
  # initial state of the tree.
  test "ruby: event targets for capturing are determined before the initial dispatch", :ruby do
    foo = document.getElementById('foo')
    triggered = []
    listener = lambda do |event|
      triggered << event.currentTarget.nodeName
      div = document.createElement('div')
      document.body.appendChild(div)
      div.appendChild(foo)
      div.addEventListener('click', lambda { triggered << event.currentTarget.nodeName }, true)
    end
  
    document.body.addEventListener('click', listener, true)
    event = document.createEvent('MouseEvents').initEvent('click')
    foo.dispatchEvent(event)
  
    assert_equal %w(BODY), triggered
  end
  
  test "js: event targets for capturing are determined before the initial dispatch", :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []
  
      document.body.addEventListener('click', { 
        handleEvent: function(event) { 
          triggered.push(event.currentTarget.nodeName)
          div = document.createElement('div')
          document.body.appendChild(div)
          div.appendChild(foo)
          div.addEventListener('click', { handleEvent: function(event) { triggered.push(event.currentTarget.nodeName) } }, true)
        }
      }, true)
      event = document.createEvent('MouseEvents').initEvent('click')
      foo.dispatchEvent(event)
    js
    
    assert_equal %w(BODY), window.evaluate("triggered").to_a
  end
  
  # The chain of EventTargets from the event target to the top of the tree is
  # determined before the initial dispatch of the event. If modifications occur
  # to the tree during event processing, event flow will proceed based on the
  # initial state of the tree.
  test "ruby: event targets for bubbling are determined before the initial dispatch", :ruby do
    foo = document.getElementById('foo')
    triggered = []
    listener = lambda do |event|
      triggered << event.currentTarget.nodeName
      div = document.createElement('div')
      document.body.appendChild(div)
      div.appendChild(foo)
      div.addEventListener('click', lambda { triggered << event.currentTarget.nodeName })
    end
  
    document.body.addEventListener('click', listener)
    event = document.createEvent('MouseEvents').initEvent('click')
    foo.dispatchEvent(event)
  
    assert_equal %w(BODY), triggered
  end
  
  test "js: event targets for bubbling are determined before the initial dispatch", :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []
  
      document.body.addEventListener('click', { 
        handleEvent: function(event) { 
          triggered.push(event.currentTarget.nodeName)
          div = document.createElement('div')
          document.body.appendChild(div)
          div.appendChild(foo)
          div.addEventListener('click', { handleEvent: function(event) { triggered.push(event.currentTarget.nodeName) } })
        }
      })
      event = document.createEvent('MouseEvents').initEvent('click')
      foo.dispatchEvent(event)
    js
    
    assert_equal %w(BODY), window.evaluate("triggered").to_a
  end
  
  # Both capturing and bubbling:
  # Any event handler may choose to prevent further event propagation by
  # calling the stopPropagation method of the Event interface. This will
  # prevent further dispatch of the event, although additional EventListeners
  # registered at the same hierarchy level will still receive the event.
  test 'ruby: stopping event propagation during capturing phase', :ruby do
    foo = document.getElementById('foo')
    triggered = []
    event = document.createEvent('MouseEvents').initEvent('click')
    
    document.addEventListener('click', lambda { triggered << 'doc:capture'; event.stopPropagation }, true)
    document.addEventListener('click', lambda { triggered << 'doc:bubble' })
    foo.addEventListener('click', lambda { triggered << 'body:capture' }, true)
    foo.addEventListener('click', lambda { triggered << 'body:bubble' })
    foo.dispatchEvent(event)
  
    assert_equal %w(doc:capture), triggered
  end
  
  test 'js: stopping event propagation during capturing phase', :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []
      listener = function(msg) {
        return { handleEvent: function(event) { triggered.push(msg); return true } };
      }
      event = document.createEvent('MouseEvents').initEvent('click')

      document.addEventListener('click', { 
        handleEvent: function(event) { triggered.push('doc:capture'); event.stopPropagation(); return true } 
      }, true)
      document.addEventListener('click', listener('doc:bubble'))
      foo.addEventListener('click', listener('body:capture'), true)
      foo.addEventListener('click', listener('body:bubble'))
  
      foo.dispatchEvent(event)
    js
  
    assert_equal %w(doc:capture), window.evaluate("triggered").to_a
  end
  
  test 'ruby: stopping event propagation during bubbling phase', :ruby do
    foo = document.getElementById('foo')
    triggered = []
    event = document.createEvent('MouseEvents').initEvent('click')

    document.addEventListener('click', lambda { triggered << 'doc:capture' }, true)
    document.addEventListener('click', lambda { triggered << 'doc:bubble' })
    foo.addEventListener('click', lambda { triggered << 'foo:bubble'; event.stopPropagation })
    foo.dispatchEvent(event)
  
    assert_equal %w(doc:capture foo:bubble), triggered
  end
  
  test 'js: stopping event propagation during bubbling phase', :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []
      listener = function(msg) {
        return { handleEvent: function(event) { triggered.push(msg); return true } };
      }
      event = document.createEvent('MouseEvents').initEvent('click')

      document.addEventListener('click', listener('doc:capture'), true)
      document.addEventListener('click', listener('doc:bubble'))
      foo.addEventListener('click', { 
        handleEvent: function(event) { triggered.push('foo:bubble'); event.stopPropagation(); return true } 
      })
      foo.dispatchEvent(event)
    js
  
    assert_equal %w(doc:capture foo:bubble), window.evaluate("triggered").to_a
  end
  
  # When a Node is copied using the cloneNode method the EventListeners attached
  # to the source Node are not attached to the copied Node.
  test 'ruby: cloneNode does not clone any attached listeners', :ruby do
    foo = document.getElementById('foo')
    triggered = []
    foo.addEventListener('click', lambda { |event| triggered << 'does not happen' })
  
    bar = foo.cloneNode(true)
    foo.parentNode.appendChild(bar)
  
    event = document.createEvent('MouseEvents').initEvent('click')
    bar.dispatchEvent(event)
  
    assert triggered.empty?
  end
  
  test 'js: cloneNode does not clone any attached listeners', :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      triggered = []

      foo.addEventListener('click', { handleEvent: function(event) { triggered.push('does not happen'); return true } })
      bar = foo.cloneNode(true)
      foo.parentNode.appendChild(bar)
  
      event = document.createEvent('MouseEvents').initEvent('click')
      bar.dispatchEvent(event)
    js
  
    assert window.evaluate("triggered").to_a.empty?
  end
  
  # The return value of dispatchEvent indicates whether any of the listeners
  # which handled the event called preventDefault. If preventDefault was called
  # the value is false, else the value is true.
  test 'ruby: dispatchEvent returns true if event.preventDefault was called', :ruby do
    foo = document.getElementById('foo')
    event = document.createEvent('MouseEvents')
    event.initEvent('click', false)
  
    foo.addEventListener('click', lambda { })
    assert !foo.dispatchEvent(event)
  
    event = document.createEvent('MouseEvents')
    event.initEvent('click', false)
  
    document.body.addEventListener('click', lambda { |event| event.preventDefault })
    assert document.body.dispatchEvent(event)
  end

  test 'js: dispatchEvent returns true if event.preventDefault was called', :js do
    window.evaluate <<-js
      foo = document.getElementById('foo')
      event = document.createEvent('MouseEvents').initEvent('click', false)
  
      foo.addEventListener('click', { handleEvent: function() { } })
    js
    assert !window.evaluate("foo.dispatchEvent(event)")
  
    window.evaluate <<-js
      event = document.createEvent('MouseEvents').initEvent('click', false)
      document.body.addEventListener('click', { handleEvent: function(event) { event.preventDefault() } })
    js
    assert window.evaluate("document.body.dispatchEvent(event)")
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