# Interface Rect (introduced in DOM Level 2)
# The Rect interface is used to represent any rect value. This interface reflects the values in the underlying style property. Hence, modifications made to the CSSPrimitiveValue objects modify the style property.
# 
# 
# IDL Definition
# // Introduced in DOM Level 2:
# interface Rect {
#   readonly attribute CSSPrimitiveValue  top;
#   readonly attribute CSSPrimitiveValue  right;
#   readonly attribute CSSPrimitiveValue  bottom;
#   readonly attribute CSSPrimitiveValue  left;
# };
# 
# Attributes
# bottom of type CSSPrimitiveValue, readonly
# This attribute is used for the bottom of the rect.
# left of type CSSPrimitiveValue, readonly
# This attribute is used for the left of the rect.
# right of type CSSPrimitiveValue, readonly
# This attribute is used for the right of the rect.
# top of type CSSPrimitiveValue, readonly
# This attribute is used for the top of the rect.