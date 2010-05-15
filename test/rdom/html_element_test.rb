require File.expand_path('../../test_helper', __FILE__)

class HtmlElementTest < Test::Unit::TestCase
  attr_reader :document, :body, :div
  
  def setup
    html = '<html><body><div id="foo">FOO</div></body></html>'
    @document = LibXML::XML::HTMLParser.string(html).parse
    @body = document.find_first('//body')
    @div = document.find_first('//div')
  end
  
  test 'innerHTML', :dom_0 do
    assert_equal '<div id="foo">FOO</div>', body.innerHTML
    assert_equal 'FOO', div.innerHTML
  end
  
  test 'innerHTML=', :dom_0 do
    div.innerHTML = '<span>bar</span><span>baz</span>'
    # TODO what's with the extra newlines and spaces?
    assert_equal "<div id=\"foo\">\n  <span>bar</span>\n  <span>baz</span>\n</div>", body.innerHTML
  end
  
  # DOM-Level-1-Core
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html#ID-745549614
  test "tagName The name of the tag for the given element", :dom_1_core do
    assert_equal 'div', div.nodeName
  end

  test "getAttribute(name) retrieves the value of the named attribute from the current node", :dom_1_core do
    assert_equal 'foo', div.getAttribute('id')
  end

  test "getAttributeNode(name) retrieves the node representation of the named attribute from the current node", :dom_1_core do
  end

  test "setAttribute(name, value) sets the value of the named attribute from the current node", :dom_1_core do
    div.setAttribute('title', 'bar')
    assert_equal 'bar', div.getAttribute('title')
  end

  test "setAttributeNode(name, attrNode) sets the node representation of the named attribute from the current node", :dom_1_core do
    attribute = document.createAttribute('boz')
    attribute.value = 'buz'
    div.setAttributeNode(attribute)
    assert_equal 'buz', div.getAttribute('boz')
  end

  test "removeAttribute(name) removes the named attribute from the current node", :dom_1_core do
    div.removeAttribute('id')
    assert_equal '<div>FOO</div>', div.to_s
  end

  test "removeAttributeNode(attrNode) removes the node representation of the named attribute from the current node", :dom_1_core do
  end

  test "getElementsByTagName(name) retrieves a set of all descendant elements, of a particular tag name, from the current element", :dom_1_core do
    elements = body.getElementsByTagName('div')
    assert_equal 1, elements.size
    assert_equal 'div', elements.first.nodeName
  end

  # DOM-Level-1-Html
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-html.html
  
  # All HTML element interfaces derive from this class. Elements that only expose 
  # the HTML core attributes are represented by the base HTMLElement interface. 
  # These elements are as follows:
  # HEAD, SUB, SUP, SPAN, BDO, TT, I, B, U, S, STRIKE, BIG, SMALL, EM, STRONG, 
  # DFN, CODE, SAMP, KBD, VAR, CITE, ACRONYM, ABBR, DD, DT, NOFRAMES, NOSCRIPT
  # ADDRESS, CENTER
  
  test "id - the id of the element", :dom_1_html do
    div.id = 'bar'
    assert_equal 'bar', div.id
    assert_equal 'bar', div.getAttribute('id')
  end

  test "title - the title attribute of the element", :dom_1_html do
    div.title = 'bar'
    assert_equal 'bar', div.title
    assert_equal 'bar', div.getAttribute('title')
  end

  test "lang - the language of an element's attributes, text, and element contents", :dom_1_html do
    div.lang = 'bar'
    assert_equal 'bar', div.lang
    assert_equal 'bar', div.getAttribute('lang')
  end

  test "dir - the directionality of the element", :dom_1_html do
    div.dir = 'bar'
    assert_equal 'bar', div.dir
    assert_equal 'bar', div.getAttribute('dir')
  end

  test "className - the class of the element", :dom_1_html do
    div.className = 'bar'
    assert_equal 'bar', div.className
    assert_equal 'bar', div.getAttribute('class')
    assert_equal '<div id="foo" class="bar">FOO</div>', div.to_s
  end

  # DOM-Level-2-Core
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Core-20001113/core.html#i-Document
  # test "getAttributeNS(namespace, name) Retrieve the value of the attribute with the specified name and namespace, from the current node", :dom_2_core do
  # end
  # 
  # test "getAttributeNodeNS(namespace, name) Retrieve the node representation of the attribute with the specified name and namespace, from the current node", :dom_2_core do
  # end
  # 
  # test "setAttributeNS(namespace, name, value) Set the value of the attribute with the specified name and namespace, from the current node", :dom_2_core do
  # end
  # 
  # test "setAttributeNodeNS(namespace, name, attrNode) Set the node representation of the attribute with the specified name and namespace, from the current node", :dom_2_core do
  # end
  # 
  # test "removeAttributeNS(namespace, name) Remove the attribute with the specified name and namespace, from the current node", :dom_2_core do
  # end

  test "hasAttribute(name) Check if the element has the specified attribute, or not", :dom_2_core do
    assert div.hasAttribute('id')
    assert !div.hasAttribute('class')
  end

  # test "hasAttributeNS(namespace, name) Check if the element has the specified attribute, in the specified namespace, or not", :dom_2_core do
  # end


  # DOM-Level-2-Events
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Events-20001113/events.html
  test "addEventListener(type, listener, useCapture) Register an event handler to a specific event type on the element" do
  end

  test "removeEventListener(type, handler, useCapture) Removes an event listener from the element" do
  end

  test "dispatchEvent(event) Dispatch an event to this node in the DOM" do
  end
end


# "clientHeight The inner height of an element"
# "clientLeft The width of the left border of an element"
# "clientTop The width of the top border of an element"
# "clientWidth The inner width of an element"
# "offsetHeight The height of an element, relative to the layout"
# "offsetLeft The distance from this element's left border to its offsetParent's left border"
# "offsetParent The element from which all offset calculations are currently computed"
# "offsetTop The distance from this element's top border to its offsetParent's top border"
# "offsetWidth The width of an element, relative to the layout"
# "scrollHeight The scroll view height of an element"
# "scrollLeft Gets/sets the left scroll offset of an element"
# "scrollTop Gets/sets the top scroll offset of an element"
# "scrollWidth The scroll view width of an element"
# "style An object representing the declarations of an element's style attributes"
# "tabIndex Gets/sets the position of the element in the tabbing order"
# "textContent Gets/sets the textual contents of an element and all its descendants"

# "blur() Removes keyboard focus from the current element"
# "click() Simulates a click on the current element"
# "compareDocumentPosition(otherNode)"
# "focus() Gives keyboard focus to the current element"
# "getBoundingClientRect()"
# "getClientRects() Returns a collection of rectangles that indicate the bounding rectangles for each line of text in a client"
# "getElementsByClassName()"
# "getElementsByTagNameNS(namespace, name) Retrieve a set of all descendant elements, of a particular tag name and namespace, from the current element"
# "isEqualNode(nodeArg)"
# "isSameNode(otherNode)"
# "scrollIntoView(alignWithTop) Scrolls the page until the element gets into the view"
