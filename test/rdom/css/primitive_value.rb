# Interface CSSPrimitiveValue (introduced in DOM Level 2)
# The CSSPrimitiveValue interface represents a single CSS value. This interface may be used to determine the value of a specific style property currently set in a block or to set a specific style property explicitly within the block. An instance of this interface might be obtained from the getPropertyCSSValue method of the CSSStyleDeclaration interface. A CSSPrimitiveValue object only occurs in a context of a CSS property.
# 
# Conversions are allowed between absolute values (from millimeters to centimeters, from degrees to radians, and so on) but not between relative values. (For example, a pixel value cannot be converted to a centimeter value.) Percentage values can't be converted since they are relative to the parent value (or another property value). There is one exception for color percentage values: since a color percentage value is relative to the range 0-255, a color percentage value can be converted to a number; (see also the RGBColor interface).
# 
# 
# IDL Definition
# // Introduced in DOM Level 2:
# interface CSSPrimitiveValue : CSSValue {
# 
#   // UnitTypes
#   const unsigned short      CSS_UNKNOWN                    = 0;
#   const unsigned short      CSS_NUMBER                     = 1;
#   const unsigned short      CSS_PERCENTAGE                 = 2;
#   const unsigned short      CSS_EMS                        = 3;
#   const unsigned short      CSS_EXS                        = 4;
#   const unsigned short      CSS_PX                         = 5;
#   const unsigned short      CSS_CM                         = 6;
#   const unsigned short      CSS_MM                         = 7;
#   const unsigned short      CSS_IN                         = 8;
#   const unsigned short      CSS_PT                         = 9;
#   const unsigned short      CSS_PC                         = 10;
#   const unsigned short      CSS_DEG                        = 11;
#   const unsigned short      CSS_RAD                        = 12;
#   const unsigned short      CSS_GRAD                       = 13;
#   const unsigned short      CSS_MS                         = 14;
#   const unsigned short      CSS_S                          = 15;
#   const unsigned short      CSS_HZ                         = 16;
#   const unsigned short      CSS_KHZ                        = 17;
#   const unsigned short      CSS_DIMENSION                  = 18;
#   const unsigned short      CSS_STRING                     = 19;
#   const unsigned short      CSS_URI                        = 20;
#   const unsigned short      CSS_IDENT                      = 21;
#   const unsigned short      CSS_ATTR                       = 22;
#   const unsigned short      CSS_COUNTER                    = 23;
#   const unsigned short      CSS_RECT                       = 24;
#   const unsigned short      CSS_RGBCOLOR                   = 25;
# 
#   readonly attribute unsigned short   primitiveType;
#   void               setFloatValue(in unsigned short unitType, 
#                                    in float floatValue)
#                                         raises(DOMException);
#   float              getFloatValue(in unsigned short unitType)
#                                         raises(DOMException);
#   void               setStringValue(in unsigned short stringType, 
#                                     in DOMString stringValue)
#                                         raises(DOMException);
#   DOMString          getStringValue()
#                                         raises(DOMException);
#   Counter            getCounterValue()
#                                         raises(DOMException);
#   Rect               getRectValue()
#                                         raises(DOMException);
#   RGBColor           getRGBColorValue()
#                                         raises(DOMException);
# };
# 
# Definition group UnitTypes
# An integer indicating which type of unit applies to the value.
# 
# Defined Constants
# CSS_ATTR
# The value is a attribute function. The value can be obtained by using the getStringValue method.
# CSS_CM
# The value is a length (cm). The value can be obtained by using the getFloatValue method.
# CSS_COUNTER
# The value is a counter or counters function. The value can be obtained by using the getCounterValue method.
# CSS_DEG
# The value is an angle (deg). The value can be obtained by using the getFloatValue method.
# CSS_DIMENSION
# The value is a number with an unknown dimension. The value can be obtained by using the getFloatValue method.
# CSS_EMS
# The value is a length (ems). The value can be obtained by using the getFloatValue method.
# CSS_EXS
# The value is a length (exs). The value can be obtained by using the getFloatValue method.
# CSS_GRAD
# The value is an angle (grad). The value can be obtained by using the getFloatValue method.
# CSS_HZ
# The value is a frequency (Hz). The value can be obtained by using the getFloatValue method.
# CSS_IDENT
# The value is an identifier. The value can be obtained by using the getStringValue method.
# CSS_IN
# The value is a length (in). The value can be obtained by using the getFloatValue method.
# CSS_KHZ
# The value is a frequency (kHz). The value can be obtained by using the getFloatValue method.
# CSS_MM
# The value is a length (mm). The value can be obtained by using the getFloatValue method.
# CSS_MS
# The value is a time (ms). The value can be obtained by using the getFloatValue method.
# CSS_NUMBER
# The value is a simple number. The value can be obtained by using the getFloatValue method.
# CSS_PC
# The value is a length (pc). The value can be obtained by using the getFloatValue method.
# CSS_PERCENTAGE
# The value is a percentage. The value can be obtained by using the getFloatValue method.
# CSS_PT
# The value is a length (pt). The value can be obtained by using the getFloatValue method.
# CSS_PX
# The value is a length (px). The value can be obtained by using the getFloatValue method.
# CSS_RAD
# The value is an angle (rad). The value can be obtained by using the getFloatValue method.
# CSS_RECT
# The value is a rect function. The value can be obtained by using the getRectValue method.
# CSS_RGBCOLOR
# The value is a RGB color. The value can be obtained by using the getRGBColorValue method.
# CSS_S
# The value is a time (s). The value can be obtained by using the getFloatValue method.
# CSS_STRING
# The value is a STRING. The value can be obtained by using the getStringValue method.
# CSS_UNKNOWN
# The value is not a recognized CSS2 value. The value can only be obtained by using the cssText attribute.
# CSS_URI
# The value is a URI. The value can be obtained by using the getStringValue method.
# Attributes
# primitiveType of type unsigned short, readonly
# The type of the value as defined by the constants specified above.
# Methods
# getCounterValue
# This method is used to get the Counter value. If this CSS value doesn't contain a counter value, a DOMException is raised. Modification to the corresponding style property can be achieved using the Counter interface.
# Return Value
# Counter
# 
# The Counter value.
# 
# Exceptions
# DOMException
# 
# INVALID_ACCESS_ERR: Raised if the CSS value doesn't contain a Counter value (e.g. this is not CSS_COUNTER).
# 
# No Parameters
# getFloatValue
# This method is used to get a float value in a specified unit. If this CSS value doesn't contain a float value or can't be converted into the specified unit, a DOMException is raised.
# Parameters
# unitType of type unsigned short
# A unit code to get the float value. The unit code can only be a float unit type (i.e. CSS_NUMBER, CSS_PERCENTAGE, CSS_EMS, CSS_EXS, CSS_PX, CSS_CM, CSS_MM, CSS_IN, CSS_PT, CSS_PC, CSS_DEG, CSS_RAD, CSS_GRAD, CSS_MS, CSS_S, CSS_HZ, CSS_KHZ, CSS_DIMENSION).
# Return Value
# float
# 
# The float value in the specified unit.
# 
# Exceptions
# DOMException
# 
# INVALID_ACCESS_ERR: Raised if the CSS value doesn't contain a float value or if the float value can't be converted into the specified unit.
# 
# getRGBColorValue
# This method is used to get the RGB color. If this CSS value doesn't contain a RGB color value, a DOMException is raised. Modification to the corresponding style property can be achieved using the RGBColor interface.
# Return Value
# RGBColor
# 
# the RGB color value.
# 
# Exceptions
# DOMException
# 
# INVALID_ACCESS_ERR: Raised if the attached property can't return a RGB color value (e.g. this is not CSS_RGBCOLOR).
# 
# No Parameters
# getRectValue
# This method is used to get the Rect value. If this CSS value doesn't contain a rect value, a DOMException is raised. Modification to the corresponding style property can be achieved using the Rect interface.
# Return Value
# Rect
# 
# The Rect value.
# 
# Exceptions
# DOMException
# 
# INVALID_ACCESS_ERR: Raised if the CSS value doesn't contain a Rect value. (e.g. this is not CSS_RECT).
# 
# No Parameters
# getStringValue
# This method is used to get the string value. If the CSS value doesn't contain a string value, a DOMException is raised.
# Note: Some properties (like 'font-family' or 'voice-family') convert a whitespace separated list of idents to a string.
# 
# Return Value
# DOMString
# 
# The string value in the current unit. The current primitiveType can only be a string unit type (i.e. CSS_STRING, CSS_URI, CSS_IDENT and CSS_ATTR).
# 
# Exceptions
# DOMException
# 
# INVALID_ACCESS_ERR: Raised if the CSS value doesn't contain a string value.
# 
# No Parameters
# setFloatValue
# A method to set the float value with a specified unit. If the property attached with this value can not accept the specified unit or the float value, the value will be unchanged and a DOMException will be raised.
# Parameters
# unitType of type unsigned short
# A unit code as defined above. The unit code can only be a float unit type (i.e. CSS_NUMBER, CSS_PERCENTAGE, CSS_EMS, CSS_EXS, CSS_PX, CSS_CM, CSS_MM, CSS_IN, CSS_PT, CSS_PC, CSS_DEG, CSS_RAD, CSS_GRAD, CSS_MS, CSS_S, CSS_HZ, CSS_KHZ, CSS_DIMENSION).
# floatValue of type float
# The new float value.
# Exceptions
# DOMException
# 
# INVALID_ACCESS_ERR: Raised if the attached property doesn't support the float value or the unit type.
# 
# NO_MODIFICATION_ALLOWED_ERR: Raised if this property is readonly.
# 
# No Return Value
# setStringValue
# A method to set the string value with the specified unit. If the property attached to this value can't accept the specified unit or the string value, the value will be unchanged and a DOMException will be raised.
# Parameters
# stringType of type unsigned short
# A string code as defined above. The string code can only be a string unit type (i.e. CSS_STRING, CSS_URI, CSS_IDENT, and CSS_ATTR).
# stringValue of type DOMString
# The new string value.
# Exceptions
# DOMException
# 
# INVALID_ACCESS_ERR: Raised if the CSS value doesn't contain a string value or if the string value can't be converted into the specified unit.
# 
# NO_MODIFICATION_ALLOWED_ERR: Raised if this property is readonly.
# 
# No Return Value