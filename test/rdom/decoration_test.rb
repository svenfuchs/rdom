require File.expand_path('../../test_helper', __FILE__)

class DecorationTest < Test::Unit::TestCase
  attr_reader :document

  def setup
    html = '<html><body><span></span><a href=""></a></body></html>'
    @document = RDom::Document.parse(html)
  end
  
  test "decoration" do
    # TODO test decoration
  end
end