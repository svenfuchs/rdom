# Interface CSSRule (introduced in DOM Level 2)
# The CSSRule interface is the abstract base interface for any type of CSS statement. This includes both rule sets and at-rules. An implementation is expected to preserve all rules specified in a CSS style sheet, even if the rule is not recognized by the parser. Unrecognized rules are represented using the CSSUnknownRule interface.
# 
# 
# IDL Definition
# // Introduced in DOM Level 2:
# interface CSSRule {
# 
#   // RuleType
#   const unsigned short      UNKNOWN_RULE                   = 0;
#   const unsigned short      STYLE_RULE                     = 1;
#   const unsigned short      CHARSET_RULE                   = 2;
#   const unsigned short      IMPORT_RULE                    = 3;
#   const unsigned short      MEDIA_RULE                     = 4;
#   const unsigned short      FONT_FACE_RULE                 = 5;
#   const unsigned short      PAGE_RULE                      = 6;
# 
#   readonly attribute unsigned short   type;
#            attribute DOMString        cssText;
#                                         // raises(DOMException) on setting
# 
#   readonly attribute CSSStyleSheet    parentStyleSheet;
#   readonly attribute CSSRule          parentRule;
# };
# 
# Definition group RuleType
# An integer indicating which type of rule this is.
# 
# Defined Constants
# CHARSET_RULE
# The rule is a CSSCharsetRule.
# FONT_FACE_RULE
# The rule is a CSSFontFaceRule.
# IMPORT_RULE
# The rule is a CSSImportRule.
# MEDIA_RULE
# The rule is a CSSMediaRule.
# PAGE_RULE
# The rule is a CSSPageRule.
# STYLE_RULE
# The rule is a CSSStyleRule.
# UNKNOWN_RULE
# The rule is a CSSUnknownRule.
# Attributes
# cssText of type DOMString
# The parsable textual representation of the rule. This reflects the current state of the rule and not its initial value.
# Exceptions on setting
# DOMException
# 
# SYNTAX_ERR: Raised if the specified CSS string value has a syntax error and is unparsable.
# 
# INVALID_MODIFICATION_ERR: Raised if the specified CSS string value represents a different type of rule than the current one.
# 
# HIERARCHY_REQUEST_ERR: Raised if the rule cannot be inserted at this point in the style sheet.
# 
# NO_MODIFICATION_ALLOWED_ERR: Raised if the rule is readonly.
# 
# parentRule of type CSSRule, readonly
# If this rule is contained inside another rule (e.g. a style rule inside an @media block), this is the containing rule. If this rule is not nested inside any other rules, this returns null.
# parentStyleSheet of type CSSStyleSheet, readonly
# The style sheet that contains this rule.
# type of type unsigned short, readonly
# The type of the rule, as defined above. The expectation is that binding-specific casting methods can be used to cast down from an instance of the CSSRule interface to the specific derived interface implied by the type.
