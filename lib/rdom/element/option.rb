# http://www.w3.org/TR/html401/interact/forms.html#edef-OPTGROUP
# <!ELEMENT OPTION - O (#PCDATA)         -- selectable choice -->
# <!ATTLIST OPTION
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   selected    (selected)     #IMPLIED
#   disabled    (disabled)     #IMPLIED  -- unavailable in this context --
#   label       %Text;         #IMPLIED  -- for use in hierarchical menus --
#   value       CDATA          #IMPLIED  -- defaults to element content --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-70901257
# interface HTMLOptionElement : HTMLElement {
#   readonly attribute HTMLFormElement form;
#   // Modified in DOM Level 2:
#            attribute boolean         defaultSelected;
#   readonly attribute DOMString       text;
#   // Modified in DOM Level 2:
#   readonly attribute long            index;
#            attribute boolean         disabled;
#            attribute DOMString       label;
#            attribute boolean         selected;
#            attribute DOMString       value;
# };
module RDom
  module Element
    module Option
      include Element, Node

      def self.extended(element)
        element.defaultSelected = element.getAttribute(:selected)
      end

      html_attributes :selected, :disabled, :label, :value

      attr_accessor :defaultSelected
      properties :defaultSelected, :form, :index

      def setAttribute(name, value)
        select.selectedIndex = -1 if name.to_sym == :selected
        super
      end

      def index
        select.options.index(self)
      end

      def selected
        # TODO define html_attribute_accessors on an included module so we can call super
        selected = Attr.unserialize(:selected, getAttribute(:selected))
        selected || select.selectedIndex == index
      end

      protected

        def select
          find_parent { |node| node.tagName == 'SELECT' }
        end
    end
  end
end