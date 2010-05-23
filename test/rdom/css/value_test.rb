# Interface CSSValue (introduced in DOM Level 2)
# The CSSValue interface represents a simple or a complex value. A CSSValue object only occurs in a context of a CSS property.
# 
# 
# IDL Definition
# // Introduced in DOM Level 2:
# interface CSSValue {
# 
#   // UnitTypes
#   const unsigned short      CSS_INHERIT                    = 0;
#   const unsigned short      CSS_PRIMITIVE_VALUE            = 1;
#   const unsigned short      CSS_VALUE_LIST                 = 2;
#   const unsigned short      CSS_CUSTOM                     = 3;
# 
#            attribute DOMString        cssText;
#                                         // raises(DOMException) on setting
# 
#   readonly attribute unsigned short   cssValueType;
# };
# 
# Definition group UnitTypes
# An integer indicating which type of unit applies to the value.
# 
# Defined Constants
# CSS_CUSTOM
# The value is a custom value.
# CSS_INHERIT
# The value is inherited and the cssText contains "inherit".
# CSS_PRIMITIVE_VALUE
# The value is a primitive value and an instance of the CSSPrimitiveValue interface can be obtained by using binding-specific casting methods on this instance of the CSSValue interface.
# CSS_VALUE_LIST
# The value is a CSSValue list and an instance of the CSSValueList interface can be obtained by using binding-specific casting methods on this instance of the CSSValue interface.
# Attributes
# cssText of type DOMString
# A string representation of the current value.
# Exceptions on setting
# DOMException
# 
# SYNTAX_ERR: Raised if the specified CSS string value has a syntax error (according to the attached property) or is unparsable.
# 
# INVALID_MODIFICATION_ERR: Raised if the specified CSS string value represents a different type of values than the values allowed by the CSS property.
# 
# NO_MODIFICATION_ALLOWED_ERR: Raised if this value is readonly.
# 
# cssValueType of type unsigned short, readonly
# A code defining the type of the value as defined above.
