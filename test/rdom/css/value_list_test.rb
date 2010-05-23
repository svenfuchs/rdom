# Interface CSSValueList (introduced in DOM Level 2)
# The CSSValueList interface provides the abstraction of an ordered collection
# of CSS values.
# 
# Some properties allow an empty list into their syntax. In that case, these
# properties take the none identifier. So, an empty list means that the
# property has the value none.
# 
# The items in the CSSValueList are accessible via an integral index, starting
# from 0.
# 
# 
# IDL Definition
# // Introduced in DOM Level 2:
# interface CSSValueList : CSSValue {
#   readonly attribute unsigned long    length;
#   CSSValue           item(in unsigned long index);
# };
# 
# Attributes
# length of type unsigned long, readonly
# The number of CSSValues in the list. The range of valid values of the indices is 0 to length-1 inclusive.
# Methods
# item
# Used to retrieve a CSSValue by ordinal index. The order in this collection represents the order of the values in the CSS style property. If index is greater than or equal to the number of values in the list, this returns null.
# Parameters
# index of type unsigned long
# Index into the collection.
# Return Value
# CSSValue
# 
# The CSSValue at the index position in the CSSValueList, or null if that is not a valid index.
# 
# No Exceptions