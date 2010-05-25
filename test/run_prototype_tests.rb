require File.expand_path('../test_helper', __FILE__)
Test::Unit.run = true # don't run tests

require 'webmock/test_unit'

ROOT_PATH = File.expand_path('../../vendor/prototype/', __FILE__)

include WebMock
stub_request(:any, /./).to_return do |request| 
  # puts "loading #{request.uri.path}"
  { :body => File.open("#{ROOT_PATH}#{request.uri.path}") { |f| f.read } }
end

window = RDom::Window.new
window.location.instance_variable_set(:@uri, URI.parse('http://example.org/test/'))
window.load("http://example.org/test/console.html")

# puts window.document.getElementById("qunit-tests")
# result = window.evaluate("jQuery('#qunit-tests > li').toArray()")
# tests = result.size
# assertions = 0
# errors = []
# 
# result.each do |tag|
#   _module = tag.firstChild.innerHTML =~ /^([^<]*)/ && $1.strip
#   tag.getElementsByTagName('li').each do |assertion|
#     assertions += 1
#     if assertion.className == 'fail'
#       errors << "#{_module}: #{assertion.textContent}" 
#       putc 'E'
#     else
#       putc '.'
#     end
#   end
# end
# 
# puts "\n\n#{tests} tests, #{assertions} assertions, #{errors.size} errors\n\n"
# errors.each { |message| puts message }
# puts