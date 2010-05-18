require File.expand_path('../../test_helper', __FILE__)

require 'webmock/test_unit'

class WindowTest < Test::Unit::TestCase
  attr_reader :window

  def setup
    @window = RDom::Window.new
    window.location.set('http://example.org')
  end

  test "load loads an html document", :implementation do
    window.load('<html></html>')
    assert_match /html/, window.document.to_s
  end

  test "load loads a file", :implementation do
    window.load(File.expand_path('../../fixtures/index.html', __FILE__))
    assert_match 'FOO', window.document.getElementById('foo').content
  end

  test "loads linked scripts", :implementation do
    stub_get('foo.js', 'document.title = "foo"')
    window.load('<html><head><title></title><script src="/foo.js"></script></head></html>')
    assert_equal 'foo', window.document.title
  end

  test "executes scripts", :implementation do
    window.load('<html><head><title></title><script>document.title = "foo";</script></head></html>')
    assert_equal 'foo', window.document.title
  end

  test "uri? returns true if the given argument is a (file or http) url, otherwise false", :implementation do
    assert window.send(:uri?, 'http://google.com')
    assert window.send(:uri?, 'file://tmp/foo.txt')

    assert !window.send(:uri?, '/tmp/foo.txt')
    assert !window.send(:uri?, '<html></html>')
  end

  test "file? returns true if the given argument is an absolute filename, otherwise false", :implementation do
    assert window.send(:file?, '/tmp/foo.txt')

    assert !window.send(:file?, 'file://tmp/foo.txt')
    assert !window.send(:file?, 'http://google.com')
    assert !window.send(:file?, '<html></html>')
  end

  # http://www.w3.org/TR/Window/

  test "The Window object has a special role as the global scope for scripts in the document in languages such as ECMAScript", :window_object_1 do
  end

  test "window.window: The value of the window attribute MUST be the same Window object that has the attribute: the attribute is a self-reference.", :window_object_1 do
  end

  test "window.self: The value of the self attribute MUST be the same Window object that has the attribute: the attribute is a self-reference. Consequently, the value of the self attribute MUST be the same object as the window attribute.", :window_object_1 do
  end

  # The value of the defaultView attribute inherited by objects that implement the
  # DocumentWindow interface inherit from the AbstractView interface MUST be the
  # default view for the browsing context presenting the document, if any. In
  # addition to the AbstractView interface, the default view MUST implement the
  # Window interface. If a document is not being presented in a browsing context
  # but nontheless implements the DocumentWindow interface, the value of the
  # defaultView attribute MUST be null.

  test "window.location: The value of the location attribute MUST be the Location object that represents the window's current location", :window_object_1 do
  end

  test "window.parent: An attribute containing a reference to Window object that contains this object", :window_object_1 do
  end

  test "window.top: An attribute containing a reference to the topmost Window object", :window_object_1 do
  end

  test "window.name: An attribute containing a unique name used to refer to this Window object", :window_object_1 do
  end

  # referencing <html:frame>, <html:iframe>, <html:object>,
  # <svg:foreignObject>, <svg:animation> or other embedding point, or null if
  # none
  test "window.frameElement", :window_object_1 do
  end

  # // must be on an object that also implements dom::Element
  # interface EmbeddingElement {
  #     readonly attribute dom::Document contentDocument;
  #     readonly attribute Window contentWindow;
  # };


  # interface Window {
  #     // should timers allow more than long, maybe a floating point type?
  #     // don't think anyone's timers have more precision
  #
  #     // one-shot timer
  #     long setTimeout(in TimerListener listener, in long milliseconds);
  #     void clearTimeout(in long timerID);
  #
  #     // repeating timer
  #     long setInterval(in TimerListener listener, in long milliseconds);
  #     void clearInterval(in long timerID);
  # };
  # setTimeout(function, milliseconds)
  # This method calls the function once after a specified number of milliseconds elapses, until canceled by a call to clearTimeout. The methods returns a timerID which may be used in a subsequent call to clearTimeout to cancel the interval.
  # setInterval(function, milliseconds)
  # This method calls the function every time a specified number of milliseconds elapses, until canceled by a call to clearInterval. The methods returns an intervalID which may be used in a subsequent call to clearInterval to cancel the interval.
  # clearTimeout(timerID)
  # Cancels a timeout that was set with the setTimeout method.
  # clearInterval(intervalID)
  # Cancels an interval that was set with the setTimeout method.

  # // behavior is always special in ECMAScript, this is defined only for the benefit
  # // of other languages
  # interface TimerListener {
  #     // what to put here?
  # };


end