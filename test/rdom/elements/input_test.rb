require File.expand_path('../../../test_helper', __FILE__)

class InputTest < Test::Unit::TestCase
  attr_reader :window, :form, :input

  def setup
    @window = RDom::Window.new('<html><body><form><input /></form></body></html>', :url => 'http://example.org')
    window.evaluate <<-js
      var form  = document.getElementsByTagName("form")[0];
      var input = document.getElementsByTagName("input")[0];
    js
    @document = window.document
    @form     = window.evaluate("form")
    @input    = window.evaluate("input")
  end

  test "ruby: input.form", :ruby do
    assert_equal form, input.form
  end
end