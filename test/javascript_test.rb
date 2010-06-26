require File.expand_path('../test_helper', __FILE__)

require 'v8'
require 'therubyracer/rdom_access'

require 'johnson/tracemonkey'
require 'johnson/js_land_proxy_patch.rb'

class JavascriptTest < Test::Unit::TestCase
  class Window
    def initialize
      @name  = 'window name'
      @ivar  = 1
      @hash  = { 'key' => 'value' }
      @array = ['value']
      @hash_like  = Accessible.new
      @array_like = Accessible.new
      @attributes = Attributes.new
    end
    
    PROPERTY_NAMES = [:name, :location, :hash, :array, :hash_like, :array_like, :attributes]
    
    attr_accessor(*PROPERTY_NAMES)
    
    def log(arg)
      "#{arg} logged"
    end
    
    def js_property?(name)
      PROPERTY_NAMES.include?(name.to_sym)
    end
  end
  
  class Accessible
    def [](name)
      'value'
    end
  end
  
  class Attributes
    def [](name)
      "attribute named '#{name}'"
    end
    
    def getNamedItem(name)
      self[name]
    end
  end
  
  attr_reader :js, :window

  def setup
    @window = Window.new
    @js = v8
  end
  
  def v8
    V8::Context.new { |js| js['window'] = window }
  end
  
  def johnson
    Johnson::Runtime.new.tap { |js| js['window'] = window }
  end
  
  test "js engine: attributes.getNamedItem returns the function getNamedItem" do
    assert_equal "function () { [native code] }", js.evaluate('window.attributes.getNamedItem').to_s
  end
  
  test "js engine: attributes.getNamedItem('name') returns the attribute 'name'" do
    assert_equal "attribute named 'name'", js.evaluate('window.attributes.getNamedItem("name")')
  end
  
  test "js engine: attributes.name returns the attribute 'name'" do
    assert_equal "attribute named 'name'", js.evaluate('window.attributes.name')
  end
  
  test "js engine: attributes['name'] returns the attribute 'name'" do
    assert_equal "attribute named 'name'", js.evaluate('window.attributes["name"]')
  end
  
  test "js engine: attributes[0] returns the first attribute" do
  end
  
  test "js engine: calling a method that is not a property returns a javascript function" do
    assert_equal 'foo logged', js.evaluate('window.log').call('foo')
  end
  
  test "js engine: calling a method that is a property evaluates the method" do
    assert_equal 'window name', js.evaluate('window.name')
  end
  
  test "js engine: calling a method with an argument that is a string" do
    assert_equal 'foo logged', js.evaluate('window.log("foo")')
  end
  
  test "js engine: calling a method with an argument that is a javascript function" do
    function = js.evaluate('window.log(function(selector, context) {})').to_s
    function.gsub!("\n", '') # johnson adds an extra newline as a method body
    assert_equal "function (selector, context) {} logged", function
  end
  
  test "js engine: calling a regular writer" do
    assert_equal 'some location', js.evaluate('window.location = "some location"; window.location')
  end
  
  test "js engine: missing method as js object property: returns nil on read" do
    assert_nil js.evaluate('window.foo')
  end
  
  test "js engine: missing method as js object property: write defines accessor and can be read in ruby" do
    js.evaluate('window.foo = "bar"')
    assert window.respond_to?(:foo)
    assert_equal 'bar', window.foo
  end
  
  test "js engine: missing method as js object property: write defines accessor and can be read in javascript" do
    js.evaluate('window.foo = "bar"')
    assert_equal 'bar', js.evaluate('window.foo')
  end
  
  test "js engine: hash access returns a regular method" do
    assert_equal 'foo logged', js.evaluate('window["log"]').call('foo')
  end
  
  test "js engine: hash access reads a property" do
    assert_equal 'window name', js.evaluate('window["name"]')
  end
  
  test "js engine: hash access on a ruby hash" do
    assert_equal 'value', js.evaluate('window.hash["key"]')
  end
  
  test "js engine: hash access on a hash like object" do
    assert_equal 'value', js.evaluate('window.hash_like')['foo']
    assert_equal 'value', js.evaluate('window.hash_like["foo"]')
  end
  
  test "js engine: index access on a ruby array" do
    assert_equal 'value', js.evaluate('window.array')[0]
    assert_equal 'value', js.evaluate('window.array[0]')
  end
  
  test "js engine: index access on an array like object" do
    assert_equal 'value', js.evaluate('window.array_like')[0]
    assert_equal 'value', js.evaluate('window.array_like[0]')
  end
  
  test "js engine: variables persist of several calls to #evaluate" do
    js.evaluate('var foo = 1;')
    assert_equal 1, js.evaluate('foo')
  end
  
  test "js engine: global $ variable" do
    js.evaluate <<-js
      jQuery = function(selector, context) {};
      _$ = window.jQuery = window.$ = jQuery;
      _$('');
    js
    function = js.evaluate('_$').to_s
    # johnson adds an extra newline as a method body
    function.gsub!("\n", '')
    assert_equal "function (selector, context) {}", function
  end

  test "js engine: does not automatically regard instance variables as js properties" do
    assert_nil js.evaluate('window.ivar')
  end
  
  test "js engine: using for on the global object" do
    keys = js.evaluate <<-js
      var keys = []
      for(var key in this) { keys.push(key) }
      keys
    js
    assert keys.include?('window')
  end
end