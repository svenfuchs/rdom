require File.expand_path('../../../test_helper', __FILE__)

class ScriptTest < Test::Unit::TestCase
  attr_reader :window, :document, :head, :script

  def setup
    @window = RDom::Window.new('<html><head><script></script></head></html>', :url => 'http://example.org')
    window.evaluate <<-js
      var head   = document.getElementsByTagName("head")[0];
      var script = document.getElementsByTagName("script")[0];
    js
    @document = window.document
    @head     = window.evaluate("head")
    @script   = window.evaluate("script")
  end

  # test "ruby: appending a text node to a script tag evaluates the text", :ruby do
  #   script.appendChild(document.createTextNode('document.title = "FOO"'))
  #   assert_equal 'FOO', document.title
  # end
  
  test "ruby: appending a script element with a body evaluates the script", :ruby do
    script = document.createElement('script');
    script.innerHTML = 'document.title = "FOO"';
    head.appendChild(script);
    assert_equal 'FOO', document.title
  end

  test "ruby: appending a script element with a src loads the element source and evaluates the script", :ruby do
    stub_request(:any, /./).to_return { |request| { :body => 'document.title = "FOO"' } }
  
    script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = "foo.js";
    head.appendChild(script);
  
    assert_equal 'FOO', document.title
  end
end