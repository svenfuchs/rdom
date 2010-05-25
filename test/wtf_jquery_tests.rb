require File.expand_path('../test_helper', __FILE__)

class JQueryTest < Test::Unit::TestCase
  attr_reader :window

  def setup
    jquery_path = File.expand_path('../../vendor/jquery/', __FILE__)
    fixtures_path = File.expand_path('../fixtures/', __FILE__)
    stub_request(:any, /./).to_return { |request| { :body => File.open("#{jquery_path}#{request.uri.path}") { |f| f.read } } }
    @window = RDom::Window.new("#{fixtures_path}/wtf_jquery.html", :url => 'http://example.org/test/')
  end

  # test "wtf jquery select val()" do
  #   window.evaluate <<-js
  #     var something = function() {
  #       jQuery("#select1").val('1').val();
  #     }
  # 
  #     test("1", function() { something(); });
  #     test("1", function() { something(); });
  #     // test("1", function() { something(); });
  #     QUnit.start();
  #   js
  # 
  #   result = window.evaluate("jQuery('#qunit-tests > li').toArray()")
  #   p result.first.textContent if result
  # end
  
  test "wtf jquery addClass" do
    window.evaluate <<-js
      test("addClass, removeClass, hasClass", function() {
       expect(14);
 
       var jq = jQuery("<p>Hi</p>"), x = jq[0];
 
       jq.addClass("hi");
       equals( x.className, "hi", "Check single added class" );
 
       jq.addClass("foo bar");
       equals( x.className, "hi foo bar", "Check more added classes" );
 
       jq.removeClass();
       equals( x.className, "", "Remove all classes" );
 
       jq.addClass("hi foo bar");
       jq.removeClass("foo");
       equals( x.className, "hi bar", "Check removal of one class" );
 
       ok( jq.hasClass("hi"), "Check has1" );
       ok( jq.hasClass("bar"), "Check has2" );
 
       var jq = jQuery("<p class='class1\\nclass2\\tcla.ss3\\n'></p>");
       ok( jq.hasClass("class1"), "Check hasClass with carriage return" );
       ok( jq.is(".class1"), "Check is with carriage return" );
       ok( jq.hasClass("class2"), "Check hasClass with tab" );
       ok( jq.is(".class2"), "Check is with tab" );
       ok( jq.hasClass("cla.ss3"), "Check hasClass with dot" );
 
       jq.removeClass("class2");
       ok( jq.hasClass("class2")==false, "Check the class has been properly removed" );
       jq.removeClass("cla");
       ok( jq.hasClass("cla.ss3"), "Check the dotted class has not been removed" );
       jq.removeClass("cla.ss3");
       ok( jq.hasClass("cla.ss3")==false, "Check the dotted class has been removed" );
      });
      QUnit.start();
    js

    result = window.evaluate("jQuery('#qunit-tests > li').toArray()")
    p result.first.textContent if result
  end
end