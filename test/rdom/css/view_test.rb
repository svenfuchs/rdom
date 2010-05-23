# Interface ViewCSS (introduced in DOM Level 2)
# This interface represents a CSS view. The getComputedStyle method provides a read only access to the computed values of an element.
# 
# The expectation is that an instance of the ViewCSS interface can be obtained by using binding-specific casting methods on an instance of the AbstractView interface.
# 
# Since a computed style is related to an Element node, if this element is removed from the document, the associated CSSStyleDeclaration and CSSValue related to this declaration are no longer valid.
# 
# 
# IDL Definition
# // Introduced in DOM Level 2:
# interface ViewCSS : views::AbstractView {
#   CSSStyleDeclaration getComputedStyle(in Element elt, 
#                                        in DOMString pseudoElt);
# };
# 
# Methods
# getComputedStyle
# This method is used to get the computed style as it is defined in [CSS2].
# Parameters
# elt of type Element
# The element whose style is to be computed. This parameter cannot be null.
# pseudoElt of type DOMString
# The pseudo-element or null if none.
# Return Value
# CSSStyleDeclaration
# 
# The computed style. The CSSStyleDeclaration is read-only and contains only absolute values.