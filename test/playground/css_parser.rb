require 'rubygems'
require 'css_parser'

parser = CssParser::Parser.new
css = <<-css
  h1, h2 { font-size: 11px !important; }
  h1.foo { font-size: 11px; }
css
parser.add_block!(css)

parser.each_selector do |selector, declarations, specificity|
  p selector
  p declarations
  p specificity
end