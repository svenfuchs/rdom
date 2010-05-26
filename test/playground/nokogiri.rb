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

# fragment = Nokogiri::HTML::DocumentFragment.parse('  <div></div>  ')
# p fragment.children

doc = Nokogiri::HTML('<html><body><input type="text" name="action" value="Test" id="text1" maxlength="30"/></body></html>')
input = doc.xpath('//input').first
p input