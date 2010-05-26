require File.expand_path('../../../test_helper', __FILE__)

class SelectTest < Test::Unit::TestCase
  attr_reader :window, :select, :first, :second, :third

  def setup
    html = <<-html
      <html>
        <body>
          <form>
            <select>
              <option value="1">first</option>
              <option value="2">second</option>
              <option value="3">third</option>
            </select>
          </form>
        </body>
      </html>
    html

    @window = RDom::Window.new(html, :url => 'http://example.org')
    window.evaluate <<-js
      var select = document.getElementsByTagName("select")[0];
      var first  = document.getElementsByTagName("option")[0];
      var second = document.getElementsByTagName("option")[1];
      var third  = document.getElementsByTagName("option")[2];
    js

    @select   = window.evaluate("select")
    @first    = window.evaluate("first")
    @second   = window.evaluate("second")
    @third    = window.evaluate("third")
  end

  test "js: select.selectedIndex", :ruby do
    assert_equal 0, window.evaluate("select.selectedIndex")
    
    window.evaluate('select.selectedIndex = 1')
    assert_equal 1, window.evaluate("select.selectedIndex")
    assert_equal true, window.evaluate("second.getAttribute('selected')")
    
    window.evaluate("third.setAttribute('selected', 'selected')")
    assert_equal 2, window.evaluate("select.selectedIndex")
  end
  
  test "js: select.selectedIndex with a single option" do
    window.evaluate("select.removeChild(second); select.removeChild(third)")
    assert_equal 0, window.evaluate("select.selectedIndex")
    assert_equal true, window.evaluate("first.selected")
  end
  
  test "js: option.selected for a disconnected option element" do
    assert_equal false, window.evaluate("document.createElement('option').selected")
    assert_equal false, window.evaluate("document.createElement('option')['selected']")
  end
end