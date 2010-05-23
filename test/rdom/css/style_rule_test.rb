# require File.expand_path('../../../test_helper', __FILE__)
# 
# class StyleRuleTest < Test::Unit::TestCase
#   attr_reader :window, :rule
# 
#   def setup
#     html = <<-html
#       <html>
#         <head>
#           <style> h1, h2 { font-size: 1.4em; } </style>
#         </head>
#       </html>
#     html
#     @window = RDom::Window.new(html, :url => 'http://example.org')
#     @rule = window.document.styleSheets[0].cssRules[0]
#   end
# 
#   # test "ruby: rule.style returns a style declaration", :ruby, :dom_2_style do
#   #   assert rule.style.respond_to?(:cssText)
#   # end
#   # 
#   # test "ruby: rule.selectorText returns a textual representation of the selector", :ruby, :dom_2_style do
#   #   assert_equal 'h1, h2', rule.selectorText
#   # end
#   # 
#   # test "ruby: rule.type returns RDom::Css::Rule::STYLE_RULE", :ruby, :dom_2_style do
#   #   assert_equal RDom::Css::Rule::STYLE_RULE, rule.type
#   # end
# end