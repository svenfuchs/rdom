require File.expand_path('../test_helper', __FILE__)
Test::Unit.run = true # don't run tests

require 'webmock/test_unit'

JQUERY_PATH = File.expand_path('../../vendor/jquery/', __FILE__)

include WebMock
stub_request(:any, /./).to_return do |request| 
  # puts "loading #{request.uri.path}"
  { :body => File.open("#{JQUERY_PATH}#{request.uri.path}") { |f| f.read } }
end

window = RDom::Window.new("http://example.org/test/index.html", :url => 'http://example.org/test/')