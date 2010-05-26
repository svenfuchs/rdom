# as we redefine Node#class as an HTML attribute, we need to make Nokogiri
# use #ruby_class for prettyprint
module Nokogiri::XML::PP::Node
  def inspect
    attributes = inspect_attributes.reject { |x|
      begin
        attribute = send x
        !attribute || (attribute.respond_to?(:empty?) && attribute.empty?)
      rescue NoMethodError
        true
      end
    }.map { |attribute|
      "#{attribute.to_s.sub(/_\w+/, 's')}=#{send(attribute).inspect}"
    }.join ' '
    "#<#{self.ruby_class.name}:#{sprintf("0x%x", object_id)} #{attributes}>"
  end
end
