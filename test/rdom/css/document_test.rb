require File.expand_path('../../../test_helper', __FILE__)

class DocumentTest < Test::Unit::TestCase
  attr_reader :window, :document, :body, :div

  def setup
    html = <<-html
      <html>
        <head>
          <style> h1, h2 { font-size: 1.4em; } </style>
        </head>
      </html>
    html
    @window = RDom::Window.new(html, :url => 'http://example.org')
    @document = window.document
  end

  # test "ruby: document.styleSheets returns a list of stylesheets", :ruby, :dom_2_style do
  #   assert_equal 'h1, h2', document.styleSheets[0].cssRules[0].selectorText
  #   # assert_equal %w(h1), document.styleSheets[0].cssRules[0].selectors
  #   # assert_equal %w(h2), document.styleSheets[1].cssRules[0].selectors
  # end
end