require File.expand_path('../../test_helper', __FILE__)

require 'webmock/test_unit'

class WindowTest < Test::Unit::TestCase
  attr_reader :window

  def setup
    @window = RDom::Window.new('<html></html>', :url => 'http://example.org')
  end

  test "load loads an html document", :implementation do
    assert_match /html/, window.document.to_s
  end

  test "load loads a file", :implementation do
    window.load(File.expand_path('../../fixtures/index.html', __FILE__))
    assert_match 'FOO', window.document.getElementById('foo').content
  end

  test "loads linked scripts", :implementation do
    stub_get('foo.js', 'document.title = "foo"')
    window.load('<html><head><title></title><script src="foo.js"></script></head></html>')
    assert_equal 'foo', window.document.title
  end

  test "executes scripts", :implementation do
    window.load('<html><head><title></title><script>document.title = "foo";</script></head></html>')
    assert_equal 'foo', window.document.title
  end

  test "sets the contentWindow property on frame elements" do
    window.load('<html><body><frame /></body></html>')
    assert !window.frames.empty?
    assert_equal window.frames.first, window.document.getElementsByTagName('frame').first.contentWindow
  end

  test "sets the contentWindow property on iframe elements" do
    window.load('<html><body><iframe /></body></html>')
    assert !window.frames.empty?
    assert_equal window.frames.first, window.document.getElementsByTagName('iframe').first.contentWindow
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
end