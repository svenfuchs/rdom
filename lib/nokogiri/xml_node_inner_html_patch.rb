module Nokogiri
  module XML
    class Node
      def fragment tags
        type = document.html? ? Nokogiri::HTML : Nokogiri::XML
        # this causes an error "`in_context': no contextual parsing on unlinked 
        # nodes (RuntimeError)". removing self from the arguments removes the
        # error. not sure this is a good idea.
        type::DocumentFragment.new(document, tags) #, self
      end
    end
  end
end