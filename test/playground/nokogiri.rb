require 'rubygems'
require 'nokogiri'

class Nokogiri::XML::Element
  def foo!
    p "FOO"
  end
end

document = Nokogiri::HTML('<html><body></body></html>')
# tag = document.xpath('//body')[0]
# tag.foo!

# p Nokogiri::XML::Comment.new(document, 'foo')

fragment = Nokogiri::HTML::DocumentFragment.parse('  <div></div>  ')
p fragment.children