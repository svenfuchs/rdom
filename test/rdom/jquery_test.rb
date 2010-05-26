require File.expand_path('../../test_helper', __FILE__)

require 'webmock/test_unit'

class JQueryTest < Test::Unit::TestCase
  attr_reader :window

  def setup
    @window = RDom::Window.new(:url => 'http://example.org')
    stub_get('jquery.js', File.open(File.expand_path('../../fixtures/jquery-1.4.2.js', __FILE__), 'r') { |f| f.read })
  end

  test "can load and use jquery", :jquery do
    # <script>$(document).ready(function() { log($("body").length) })</script>
    window.load <<-html
      <html>
        <head>
          <script src="http://example.org/jquery.js"></script>
          <script>
            var foo = -1;
            $(document).ready(function() { foo = $("body").length });
          </script>
        </head>
        <body></body>
      </html>
    html
    assert_equal 1, window.evaluate('foo')
  end

  test "jquery selectors: div", :jquery do
    window.load <<-html
      <html>
        <head><script src="http://example.org/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$("div").length')
  end

  test "jquery selectors: #foo", :jquery do
    window.load <<-html
      <html>
        <head><script src="http://example.org/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$("#foo").length')
  end

  test "jquery selectors: #foo ol li", :jquery do
    window.load <<-html
      <html>
        <head><script src="http://example.org/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$("#foo ol li").length')
  end

  test "jquery selectors: .bar", :jquery do
    window.load <<-html
      <html>
        <head><script src="http://example.org/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$(".bar").length')
  end

  test "jquery selectors: ol:nth-child(1)", :jquery do
    window.load <<-html
      <html>
        <head><script src="http://example.org/jquery.js"></script></head>
        <body><div id="foo"><ol><li class="bar"></li></ol></div></body>
      </html>
    html
    assert_equal 1, window.evaluate('$("ol:nth-child(1)").length')
  end
  
  test "jquery dom generation", :jquery do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    html = window.evaluate("jQuery('<div id=\"foo\"/><hr><code>code</code>').toArray()").join('')
    assert_equal '<div id="foo"></div><hr><code>code</code>', html
  end

  test "jquery dom generation with attributes", :jquery do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
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
    assert_equal 'DIV', tag.nodeName
    assert_equal 'test', tag.textContent
  end

  # test "jquery can click on an element generated through dom generation with attributes", :jquery do
  #   window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
  #   tag = window.evaluate <<-js
  #     var clicked = false
  #     var element = jQuery("<div/>", { click: function(){ clicked = true; } })[0];
  #     element.click();
  #   js
  #   assert_equal true, window.evaluate("clicked")
  # end

  test "jquery parseJSON", :jquery do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert_equal nil, window.evaluate('jQuery.parseJSON()')
    assert_equal nil, window.evaluate('jQuery.parseJSON(null)')
    assert_equal 1,   window.evaluate('jQuery.parseJSON(\'{"test":1}\')')['test']
  end
  
  test "jQuery.support.leadingWhitespace == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.leadingWhitespace')
  end
  
  test "jQuery.support.tbody == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.tbody')
  end
  
  test "jQuery.support.htmlSerialize == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.htmlSerialize')
  end
  
  test "jQuery.support.style == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.style')
  end
  
  test "jQuery.support.hrefNormalized == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.hrefNormalized')
  end
  
  # TODO gotta parse styles
  test "jQuery.support.opacity == false" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert !window.evaluate('jQuery.support.opacity')
  end
  
  # TODO gotta parse styles
  test "jQuery.support.cssFloat == false" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert !window.evaluate('jQuery.support.cssFloat')
  end
  
  # seems ok as jquery says webkit doesn't do this either
  test "jQuery.support.checkOn == false" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert !window.evaluate('jQuery.support.checkOn')
  end
  
  test "jQuery.support.optSelected == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.optSelected')
  end
  
  test "jQuery.support.parentNode == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.parentNode')
  end
  
  test "jQuery.support.deleteExpando == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.deleteExpando')
  end
  
  test "jQuery.support.checkClone == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.checkClone')
  end
  
  test "jQuery.support.scriptEval == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.scriptEval')
  end
  
  test "jQuery.support.noCloneEvent == true" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert window.evaluate('jQuery.support.noCloneEvent')
  end
  
  # seems ok as we'd need to implement the full box model for this?
  test "jQuery.support.boxModel == false" do
    window.load('<html><head><script src="http://example.org/jquery.js"></script></head><body></body></html>')
    assert !window.evaluate('jQuery.support.boxModel')
  end
  
  test "jquery html()" do
    window.load <<-html
      <html>
        <head><script src="http://example.org/jquery.js"></script></head>
        <body><div id="wrap">#{'<div>foo</div>' * 100}</div></body>
      </html>
    html
    window.evaluate <<-js
      var html = $('#wrap')[0].innerHTML;
      function reset() { $('#wrap').html(html); }
			reset();
			reset();
    js
    assert_equal 100, window.evaluate("$('#wrap div').length")
  end
end