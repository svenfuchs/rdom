require 'rubygems'
require 'xml'
require 'libxml'

class LibXML::XML::Node
  def foo!
    p "FOO"
  end
end

document = LibXML::XML::HTMLParser.string('<html><body></body></html>').parse
tag = document.find('//body')[0]
p tag.class
tag.foo!