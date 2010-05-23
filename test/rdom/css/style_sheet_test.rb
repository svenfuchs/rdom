# Interface CSSStyleSheet (introduced in DOM Level 2)
# The CSSStyleSheet interface is a concrete interface used to represent a CSS 
# style sheet i.e., a style sheet whose content type is "text/css".
# 
# 
# IDL Definition
# // Introduced in DOM Level 2:
# interface CSSStyleSheet : stylesheets::StyleSheet {
#   readonly attribute CSSRule          ownerRule;
#   readonly attribute CSSRuleList      cssRules;
#   unsigned long      insertRule(in DOMString rule, 
#                                 in unsigned long index)
#                                         raises(DOMException);
#   void               deleteRule(in unsigned long index)
#                                         raises(DOMException);
# };
# 
# Attributes
# cssRules of type CSSRuleList, readonly
# The list of all CSS rules contained within the style sheet. This includes both rule sets and at-rules.
# ownerRule of type CSSRule, readonly
# If this style sheet comes from an @import rule, the ownerRule attribute will contain the CSSImportRule. In that case, the ownerNode attribute in the StyleSheet interface will be null. If the style sheet comes from an element or a processing instruction, the ownerRule attribute will be null and the ownerNode attribute will contain the Node.
# Methods
# deleteRule
# Used to delete a rule from the style sheet.
# Parameters
# index of type unsigned long
# The index within the style sheet's rule list of the rule to remove.
# Exceptions
# DOMException
# 
# INDEX_SIZE_ERR: Raised if the specified index does not correspond to a rule in the style sheet's rule list.
# 
# NO_MODIFICATION_ALLOWED_ERR: Raised if this style sheet is readonly.
# 
# No Return Value
# insertRule
# Used to insert a new rule into the style sheet. The new rule now becomes part of the cascade.
# Parameters
# rule of type DOMString
# The parsable text representing the rule. For rule sets this contains both the selector and the style declaration. For at-rules, this specifies both the at-identifier and the rule content.
# index of type unsigned long
# The index within the style sheet's rule list of the rule before which to insert the specified rule. If the specified index is equal to the length of the style sheet's rule collection, the rule will be added to the end of the style sheet.
# Return Value
# unsigned long
# 
# The index within the style sheet's rule collection of the newly inserted rule.
# 
# Exceptions
# DOMException
# 
# HIERARCHY_REQUEST_ERR: Raised if the rule cannot be inserted at the specified index e.g. if an @import rule is inserted after a standard rule set or other at-rule.
# 
# INDEX_SIZE_ERR: Raised if the specified index is not a valid insertion point.
# 
# NO_MODIFICATION_ALLOWED_ERR: Raised if this style sheet is readonly.
# 
# SYNTAX_ERR: Raised if the specified rule has a syntax error and is unparsable.