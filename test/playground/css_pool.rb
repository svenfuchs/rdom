require 'rubygems'
require 'csspool'

doc = CSSPool.CSS <<-css
  h1, h2 { font-size: 11px !important; }
  h1.foo { font-size: 11px; }
css
doc.rule_sets.each do |rs|
  puts rs.to_css
end

puts doc.to_css
