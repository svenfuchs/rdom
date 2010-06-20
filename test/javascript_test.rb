require File.expand_path('../test_helper', __FILE__)

# require 'webmock/test_unit'
require 'v8'
require 'therubyracer/rdom_access'

class JavascriptTest < Test::Unit::TestCase
  class Window
    def initialize
      @name = 'window name'
      @some_hash  = { 'key' => 'value' }
      @some_attrs = Attributes.new
      @some_array = []
      @some_list  = List.new
      @some_ivar  = 1
    end
    
    PROPERTY_NAMES = [:name, :location, :some_hash, :some_attrs, :some_array, :some_list]
    
    attr_accessor *PROPERTY_NAMES
    
    def log(arg) # a regular method taking an argument
      "#{arg} logged"
    end
    
    def js_property?(name)
      PROPERTY_NAMES.include?(name.to_sym)
    end
  end
  
  class Attributes
    def [](name)
      'value'
    end
  end
  
  class List
    def [](index)
      'value'
    end
  end
  
  attr_reader :js, :window

  def setup
    @window = Window.new
    @js = V8::Context.new { |js| js['window'] = window }
  end
  
  test "js engine: calling a method that is not a property returns a javascript function" do
    assert_equal 'foo logged', js.eval('window.log').call('foo')
  end
  
  test "js engine: calling a method that is a property evaluates the method" do
    assert_equal 'window name', js.eval('window.name')
  end
  
  test "js engine: calling a method with an argument that is a string" do
    assert_equal 'foo logged', js.eval('window.log("foo")')
  end
  
  test "js engine: calling a method with an argument that is a javascript function" do
    assert_equal 'function () {} logged', js.eval('window.log(function() {})')
  end
  
  test "js engine: calling a regular writer" do
    assert_equal 'some location', js.eval('window.location = "some location"; window.location')
  end
  
  test "js engine: missing method as js object property: returns nil on read" do
    assert_nil js.eval('window.foo')
  end
  
  test "js engine: missing method as js object property: write defines accessor and can be read in ruby" do
    js.eval('window.foo = "bar"')
    assert window.respond_to?(:foo)
    assert_equal 'bar', window.foo
  end
  
  test "js engine: missing method as js object property: write defines accessor and can be read in javascript" do
    js.eval('window.foo = "bar"')
    assert_equal 'bar', js.eval('window.foo')
  end
  
  test "js engine: hash access returns a regular method" do
    assert_equal 'foo logged', js.eval('window["log"]').call('foo')
  end
  
  test "js engine: hash access reads a property" do
    assert_equal 'window name', js.eval('window["name"]')
  end
  
  test "js engine: hash access on a ruby hash" do
    assert_equal 'value', js.eval('window.some_hash["key"]')
  end
  
  test "js engine: hash access on a hash like object" do
    assert_equal 'value', js.eval('window.some_attrs')['foo']
    assert_equal 'value', js.eval('window.some_attrs["foo"]')
  end
  
  test "js engine: index access on a ruby array" do
    assert_equal 'value', js.eval('window.some_array')[1]
    assert_equal 'value', js.eval('window.some_array[1]')
  end
  
  test "js engine: index access on an array like object" do
    assert_equal 'value', js.eval('window.some_list')[1]
    assert_equal 'value', js.eval('window.some_list[1]')
  end
  
  test "js engine: global $ variable" do
    js.eval <<-js
      jQuery = function(selector, context) {};
      _$ = window.jQuery = window.$ = jQuery;
      _$('');
    js
    assert_equal "function (selector, context) {}", js.eval('_$').to_s
  end

  test "js engine: does not automatically regard instance variables as js properties" do
    assert_nil js.eval('window.some_ivar')
  end
  
  test "js engine: using for on the global object" do
    keys = js.eval <<-js
      var keys = []
      for(var key in this) { keys.push(key) }
      keys
    js
    assert keys.include?('window')
  end
end