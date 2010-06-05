require File.expand_path('../../test_helper', __FILE__)

require 'webmock/test_unit'

class JavascriptTest < Test::Unit::TestCase
  attr_reader :window, :document, :console

  def setup
    @window = RDom::Window.new
    window.load("<html></html>")

    @document = @window.document
    @console  = @window.console
  end

  test "johnson does not regard instance variables as js properties" do
    window.evaluate 'console.log("foo");'
    window.evaluate 'console.log("foo");'

    assert window.evaluate('console.log')
    assert_equal %w(foo foo), window.console.log.flatten
  end

  test "calls to missing methods are treated like js object properties" do
    window.evaluate 'console.log(document.foo)'
    assert_equal nil, console.last_item

    window.evaluate 'document.foo = "bar"'
    assert document.respond_to?(:foo)
    assert_equal 'bar', document.foo

    window.evaluate 'console.log(document.foo)'
    assert_equal 'bar', console.last_item
  end

  test "global $ variable" do
    window.evaluate <<-js
      jQuery = function(selector, context) {};
      _$ = window.jQuery = window.$ = jQuery;
      _$('');
    js
    assert_equal "function (selector, context) {\n}", window.evaluate('_$').to_s
  end

  test "calling a ruby method with an argument that is a javascript function" do
    class << window; def foo(bar); end; end
    assert_nothing_raised do
      window.evaluate <<-js
        jQuery = function(selector, context) {};
        foo(jQuery)
      js
    end
  end

  test "using for on the global object" do
    keys = window.evaluate <<-js
      var keys = []
      for(var key in this) { keys.push(key) }
      keys
    js
    assert keys.include?('document')
  end
end