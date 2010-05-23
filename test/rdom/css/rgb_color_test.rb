# Interface RGBColor (introduced in DOM Level 2)
# The RGBColor interface is used to represent any RGB color value. This interface reflects the values in the underlying style property. Hence, modifications made to the CSSPrimitiveValue objects modify the style property.
# 
# A specified RGB color is not clipped (even if the number is outside the range 0-255 or 0%-100%). A computed RGB color is clipped depending on the device.
# 
# Even if a style sheet can only contain an integer for a color value, the internal storage of this integer is a float, and this can be used as a float in the specified or the computed style.
# 
# A color percentage value can always be converted to a number and vice versa.
# 
# 
# IDL Definition
# // Introduced in DOM Level 2:
# interface RGBColor {
#   readonly attribute CSSPrimitiveValue  red;
#   readonly attribute CSSPrimitiveValue  green;
#   readonly attribute CSSPrimitiveValue  blue;
# };
# 
# Attributes
# blue of type CSSPrimitiveValue, readonly
# This attribute is used for the blue value of the RGB color.
# green of type CSSPrimitiveValue, readonly
# This attribute is used for the green value of the RGB color.
# red of type CSSPrimitiveValue, readonly
# This attribute is used for the red value of the RGB color.