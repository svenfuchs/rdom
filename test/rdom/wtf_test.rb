# require File.expand_path('../../test_helper', __FILE__)
# 
# require 'webmock/test_unit'
# 
# FIXTURES_PATH = File.expand_path('../../fixtures/', __FILE__)
# JQUERY_PATH = File.expand_path('../../../vendor/jquery/', __FILE__)
# 
# class JQueryTest < Test::Unit::TestCase
#   attr_reader :window
# 
#   def setup
#     stub_request(:any, /./).to_return { |request| { :body => File.open("#{JQUERY_PATH}#{request.uri.path}") { |f| f.read } } }
#     @window = RDom::Window.new("#{FIXTURES_PATH}/wtf_jquery.html", :url => 'http://example.org/test/')
#   end
# 
#   # test "wtf jquery" do
#   #   window.evaluate <<-js
#   #     var something = function(valueObj) {
#   #       jQuery("#select1").val(3).val();
#   #     }
#   # 
#   #     test("1", function() { something(); });
#   #     test("2", function() { something(); })
#   #     QUnit.start();
#   #   js
#   # 
#   #   result = window.evaluate("jQuery('#qunit-tests > li').toArray()")
#   #   p result.first.textContent if result
#   # end
# end