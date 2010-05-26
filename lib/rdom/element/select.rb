# http://www.w3.org/TR/html401/interact/forms.html#edef-SELECT
# <!ELEMENT SELECT - - (OPTGROUP|OPTION)+ -- option selector -->
# <!ATTLIST SELECT
#   %attrs;                              -- %coreattrs, %i18n, %events --
#   name        CDATA          #IMPLIED  -- field name --
#   size        NUMBER         #IMPLIED  -- rows visible --
#   multiple    (multiple)     #IMPLIED  -- default is single selection --
#   disabled    (disabled)     #IMPLIED  -- unavailable in this context --
#   tabindex    NUMBER         #IMPLIED  -- position in tabbing order --
#   onfocus     %Script;       #IMPLIED  -- the element got the focus --
#   onblur      %Script;       #IMPLIED  -- the element lost the focus --
#   onchange    %Script;       #IMPLIED  -- the element value was changed --
#   >
#
# http://www.w3.org/TR/DOM-Level-2-HTML/html.html#ID-94282980
# interface HTMLSelectElement : HTMLElement {
#   readonly attribute DOMString       type;
#            attribute long            selectedIndex;
#            attribute DOMString       value;
#   // Modified in DOM Level 2:
#            attribute unsigned long   length;
#                                         // raises(DOMException) on setting
#
#   readonly attribute HTMLFormElement form;
#   // Modified in DOM Level 2:
#   readonly attribute HTMLOptionsCollection options;
#            attribute boolean         disabled;
#            attribute boolean         multiple;
#            attribute DOMString       name;
#            attribute long            size;
#            attribute long            tabIndex;
#   void               add(in HTMLElement element,
#                          in HTMLElement before)
#                                         raises(DOMException);
#   void               remove(in long index);
#   void               blur();
#   void               focus();
# };
module RDom
  module Element
    module Select
      include Element, Node

      properties :form, :options, :length, :selectedIndex, :value, :type
      html_attributes :disabled, :multiple, :name, :size, :tabIndex, :onfocus, :onblur, :onchange

      def type
        getAttribute(:multiple) ? 'select-multiple' : 'select-one'
      end

      def value
        option = options[selectedIndex] if selectedIndex > -1
        option ? option.value : ''
      end

      # TODO multiple select
      def selectedIndex
        option = options.detect { |option| option.getAttribute('selected') }
        option ? option.index : 0
      end

      def selectedIndex=(index)
        options.each do |option|
          if option.index == index
            option.setAttribute('selected', 'selected') && !option.getAttribute('selected')
          else
            option.removeAttribute('selected')
          end
        end
      end

      def options
        getElementsByTagName('option')
      end

      def length
        options.size
      end

      # TODO blur, focus

      def form
        find_parent_by_tag_name('FORM')
      end
    end
  end
end