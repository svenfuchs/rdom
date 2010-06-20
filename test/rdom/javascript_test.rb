require File.expand_path('../../test_helper', __FILE__)

require 'webmock/test_unit'

class JavascriptTest < Test::Unit::TestCase
  attr_reader :window, :document, :console

  def setup
    @window = RDom::Window.new
    window.load("<html><body><p>foo</p></body></html>")

    @document = @window.document
    @console  = @window.console
  end

  test "js engine: missing method as js object property: returns nil on read" do
    assert_nil window.evaluate('document.foo')
  end
  
  test "js engine: missing method as js object property: write defines accessor and can read in ruby" do
    window.evaluate 'document.foo = "bar"'
    assert document.respond_to?(:foo)
    assert_equal 'bar', document.foo
  end
  
  test "js engine: missing method as js object property: write defines accessor and can read in javascript" do
    window.evaluate 'document.foo = "bar"'
    window.evaluate 'console.log(document.foo)'
    assert_equal 'bar', console.last_item
  end
  
  # test "js engine: global $ variable" do
  #   window.evaluate <<-js
  #     jQuery = function(selector, context) {};
  #     _$ = window.jQuery = window.$ = jQuery;
  #     _$('');
  #   js
  #   assert_equal "function (selector, context) {}", window.evaluate('_$').to_s
  # end
  
  test "js engine: can call a ruby method" do
    assert_nothing_raised do
      window.evaluate('document.body')
    end
  end
  
  test "js engine: can call a ruby method with a javascript function as an argument" do
    assert_nothing_raised do
      window.evaluate('console.log(function(selector, context) {})')
    end
  end
  
  test "js engine: does not regard instance variables as js properties" do
    window.evaluate 'console.log("foo");'
    window.evaluate 'console.log("foo");'
  
    assert window.evaluate('console.log')
    assert_equal %w(foo foo), window.console.log.flatten
  end
  
  test "js engine: using for on the global object" do
    keys = window.evaluate <<-js
      var keys = []
      for(var key in this) { keys.push(key) }
      keys
    js
    assert keys.include?('document')
  end
end