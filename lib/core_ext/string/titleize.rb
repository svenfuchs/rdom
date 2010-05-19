require 'core_ext/string/underscore'

class String
  def titleize
    dup.underscore.gsub(/\b('?[a-z])/) { $1.capitalize }
  end
end unless String.method_defined?(:titleize)
