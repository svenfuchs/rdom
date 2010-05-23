require File.expand_path('../../../test_helper', __FILE__)

class StyleDeclarationTest < Test::Unit::TestCase
  attr_reader :window, :style

  def setup
    html = <<-html
      <html>
        <head><style> h1, h2 { font-size: 1.4em !important; } </style></head>
        <body style="clear: left;"></body>
      </html>
    html
    @window = RDom::Window.new(html, :url => 'http://example.org')
    # @style = window.document.styleSheets[0].cssRules[0].style
  end

  # the style object is accessed from the document or from the elements to which
  # that style is applied. It represents the in-line styles on a particular
  # element.
  [:background, :clear, :display, :position, :width, :zIndex].each do |name|
    test "has style property #{name}" do
      style = window.document.body.style
      assert style.respond_to?(name)
      assert style.respond_to?(:"#{name}=")
      assert style.js_property?(name)
    end
  end

  test "style properties are populated from the element's style attribute" do
    style = window.document.body.style
    assert_equal 'left', style.clear
  end

  # # you cannot set values directly using constructions such as element.style=
  # # "background:blue", where the string contains both the attribute ("background")
  # # and the value ("blue").
  # test "TODO check what's happening here. ignore it? or raise a read-only exception" do
  # end
  # 
  # # Use instead element.style.cssText= "background:blue"
  # test "setting cssText parses the given css text to the style declaration using style.property_name" do
  # end
  # 
  # # You can also change style of an element by getting a reference to it and
  # # then use its setAttribute method to specify the CSS property and its value.
  # test "setting cssText parses the given css text to the style declaration using setAttribute()" do
  # end
  # 
  # # setAttribute will remove all other style properties that may already have
  # # been defined in the element's style object.
  # test "setting cssText resets the style declaration" do
  # end
  # 
  # # The parsable textual representation of the declaration block (excluding the surrounding curly braces)
  # # Setting this attribute will result in the parsing of the new value and resetting of all the properties 
  # # in the declaration block including the removal or addition of properties.
  # test "ruby: cssText", :ruby, :dom_2_style do
  #   assert_equal 'font-size: 1.4em !important;', style.cssText
  # end
  # 
  # # Used to retrieve the value of a CSS property if it has been explicitly set 
  # # within this declaration block.
  # test "ruby: getPropertyValue", :ruby, :dom_2_style do
  #   assert_equal '1.4em', style.getPropertyValue('font-size')
  # end
  # 
  # # Used to retrieve the priority of a CSS property (e.g. the "important"
  # # qualifier) if the property has been explicitly set in this declaration block.
  # test "ruby: getPropertyPriority", :ruby, :dom_2_style do
  #   assert_equal 'important', style.getPropertyPriority('font-size')
  # end
  # 
  # # Used to set a property value and priority within this declaration block.
  # test "ruby: setProperty", :ruby, :dom_2_style do
  #   style.setProperty('color', 'blue')
  #   assert_equal 'blue', style.getPropertyValue('color')
  #   assert style.cssText.include?('color: blue;')
  # end
  # 
  # # Used to remove a CSS property if it has been explicitly set within this declaration block.
  # test "ruby: removeProperty", :ruby, :dom_2_style do
  #   style.setProperty('color', 'blue')
  #   style.removeProperty('color')
  #   assert_equal 'font-size: 1.4em !important;', style.cssText
  # end
  # 
  # # Used to retrieve the properties that have been explicitly set in this
  # # declaration block. The order of the properties retrieved using this method
  # # does not have to be the order in which they were set. This method can be
  # # used to iterate over all properties in this declaration block.
  # test "ruby: item", :ruby, :dom_2_style do
  #   assert style.item(0)
  #   assert_nil style.item(1)
  # end
  # 
  # # The number of properties that have been explicitly set in this declaration block.
  # test "ruby: length", :ruby, :dom_2_style do
  #   assert_equal 1, style.length
  # end
  # 
  # # The CSS rule that contains this declaration block or null if this CSSStyleDeclaration is not attached to a CSSRule.
  # test "ruby: parentRule", :ruby, :dom_2_style do
  #   assert style.parentRule.respond_to?(:selectorText)
  # end
end