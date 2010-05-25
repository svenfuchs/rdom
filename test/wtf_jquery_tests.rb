require File.expand_path('../test_helper', __FILE__)

class JQueryTest < Test::Unit::TestCase
  attr_reader :window

  def setup
    jquery_path = File.expand_path('../../vendor/jquery/', __FILE__)
    fixtures_path = File.expand_path('../fixtures/', __FILE__)
    stub_request(:any, /./).to_return { |request| { :body => File.open("#{jquery_path}#{request.uri.path}") { |f| f.read } } }
    @window = RDom::Window.new("#{fixtures_path}/wtf_jquery.html", :url => 'http://example.org/test/')
  end

  test "wtf jquery" do
    window.evaluate <<-js
      var something = function() {
        jQuery("#select1").val('1').val();
      }

      test("1", function() { something(); });
      test("1", function() { something(); });
      test("1", function() { something(); });
      QUnit.start();
    js

    result = window.evaluate("jQuery('#qunit-tests > li').toArray()")
    p result.first.textContent if result
  end
end