# A CSSStyleDeclaration is an interface to the declaration block returned by the
# style property of a cssRule in a stylesheet, when the rule is a CSSStyleRule.
#
# CSSStyleDeclaration is also a read-only interface to the result of
# getComputedStyle.
module RDom
  module Css
    class StyleDeclaration < Hash
      undef :clear, :[], :[]=

      # https://developer.mozilla.org/en/DOM/CSS
      properties :azimuth, :background, :backgroundAttachment, :backgroundColor,
                 :backgroundImage, :backgroundPosition, :backgroundRepeat, :border,
                 :borderBottom, :borderBottomColor, :borderBottomStyle, :borderBottomWidth,
                 :borderCollapse, :borderColor, :borderLeft, :borderLeftColor,
                 :borderLeftStyle, :borderLeftWidth, :borderRight, :borderRightColor,
                 :borderRightStyle, :borderRightWidth, :borderSpacing, :borderStyle,
                 :borderTop, :borderTopColor, :borderTopStyle, :borderTopWidth, :borderWidth,
                 :bottom, :captionSide, :clear, :clip, :color, :content, :counterIncrement,
                 :counterReset, :cssFloat, :cue, :cueAfter, :cueBefore, :cursor, :direction,
                 :display, :elevation, :emptyCells, :font, :fontFamily, :fontSize,
                 :fontSizeAdjust, :fontStretch, :fontStyle, :fontVariant, :fontWeight, :height,
                 :left, :letterSpacing, :lineHeight, :listStyle, :listStyleImage,
                 :listStylePosition, :listStyleType, :margin, :marginBottom, :marginLeft,
                 :marginRight, :marginTop, :markerOffset, :marks, :maxHeight, :maxWidth,
                 :minHeight, :minWidth, :opacity, :orphans, :outline, :outlineColor,
                 :outlineOffset, :outlineStyle, :outlineWidth, :overflow, :overflowX,
                 :overflowY, :padding, :paddingBottom, :paddingLeft, :paddingRight,
                 :paddingTop, :page, :pageBreakAfter, :pageBreakBefore, :pageBreakInside,
                 :pause, :pauseAfter, :pauseBefore, :pitch, :pitchRange, :position, :quotes,
                 :richness, :right, :size, :speak, :speakHeader, :speakNumeral,
                 :speakPunctuation, :speechRate, :stress, :tableLayout, :textAlign,
                 :textDecoration, :textIndent, :textShadow, :textTransform, :top, :unicodeBidi,
                 :verticalAlign, :visibility, :voiceFamily, :volume, :whiteSpace, :widows,
                 :width, :wordSpacing, :wordWrap, :zIndex

      @property_names.each do |name|
        define_method(name) { getPropertyValue(name) || '' }
        define_method(:"#{name}=") { |value| setProperty(name, value) }
      end

      def initialize(parent, css)
        @parent = parent
        parse(css).each do |element| 
          setProperty(element.name, element.value, element.priority)
        end if css
      end

      # The containing cssRule.
      def parentRule
        @parent
      end

      # Textual representation of the declaration block. Setting this attribute changes the style.
      def cssText
        keys.inject('') do |result, name|
          importance = getPropertyPriority(name)
          importance = " !#{importance}" if importance
          result << "#{name}: #{getPropertyValue(name)}#{importance};"
        end
      end

      # The number of properties.
      def length
        super
      end

      # Returns a property name.
      def item(ix)
        self.fetch(keys[ix])
      end

      # Returns the property value.
      def getPropertyValue(name)
        self.fetch(name).value if key?(name)
      end

      # Returns the optional priority, "important".
      def getPropertyPriority(name)
        self.fetch(name).priority if key?(name)
      end

      def setProperty(name, value, priority = '')
        self.store(name, StyleProperty.new(name, value, priority))
      end

      def removeProperty(name)
        delete(name.to_sym)
      end

      def getPropertyCSSValue(name)
        # deprecated: http://lists.w3.org/Archives/Public/www-style/2003Oct/0347.html
        raise(NotImplementedError.new("not implemented: #{self.class.name}#getPropertyCSSValue"))
      end
      
      def respond_to?(name)
        property?(name) || super
      end

      protected
      
        def fetch(key)
          super(key.to_sym)
        end
        
        def store(key, value)
          super(key.to_sym, value)
        end

        def parse(css)
          PropertiesParser.new.parse(css).elements
        rescue
          []
        end
    end
  end
end