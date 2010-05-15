require File.expand_path('../../test_helper', __FILE__)

require 'webmock/test_unit'

class JQueryTest < Test::Unit::TestCase
  attr_reader :window

  def setup
    @window = RDom::Window.new
    window.location.instance_variable_set(:@uri, URI.parse('http://example.org'))
    stub_get('jquery.js', File.open(File.expand_path('../../fixtures/jquery-1.4.2.js', __FILE__), 'r') { |f| f.read })
  end

  test "can load and use jquery", :jquery do
    window.load <<-html
      <html>
        <head>
          <script src="/jquery.js"></script>
          <script>$(document).ready(function() { log($("body").length) })</script>
        </head>
        <body></body>
      </html>
    html
    assert_equal 1, window.console.log.last.last
  end

  test "jquery selectors: div", :jquery do
    window.load <<-html
      <html>
        <head><script src="/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$("div").length')
  end

  test "jquery selectors: #foo", :jquery do
    window.load <<-html
      <html>
        <head><script src="/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$("#foo").length')
  end

  test "jquery selectors: #foo ol li", :jquery do
    window.load <<-html
      <html>
        <head><script src="/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$("#foo ol li").length')
  end

  test "jquery selectors: .bar", :jquery do
    window.load <<-html
      <html>
        <head><script src="/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$(".bar").length')
  end

  test "jquery selectors: ol:nth-child(1)", :jquery do
    window.load <<-html
      <html>
        <head><script src="/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$("ol:nth-child(1)").length')
  end
  
  test "jquery dom generation", :jquery do
    window.load('<html><head><script src="/jquery.js"></script></head><body></body></html>')
    html = window.evaluate("jQuery('<div id=\"foo\"/><hr><code>code</code>').toArray()").join('')
    assert_equal '<div id="foo"/><hr/><code>code</code>', html
  end

  test "jquery dom generation with attributes", :jquery do
    window.load('<html><head><script src="/jquery.js"></script></head><body></body></html>')
    tag = window.evaluate <<-js
      jQuery("<div/>", {
        width: 10,
        css: { paddingLeft:1, paddingRight:1 },
        click: function(){ ok(exec, "Click executed."); },
        text: "test",
        "class": "test2",
        id: "test3"
      })[0];
    js
    assert_equal 'div', tag.nodeName
    assert_equal 'test', tag.textContent
  end

  test "jquery parseJSON", :jquery do
    window.load('<html><head><script src="/jquery.js"></script></head><body></body></html>')
    assert_equal nil, window.evaluate('jQuery.parseJSON()')
    assert_equal nil, window.evaluate('jQuery.parseJSON(null)')
    assert_equal 1,   window.evaluate('jQuery.parseJSON(\'{"test":1}\')')['test']
  end
end