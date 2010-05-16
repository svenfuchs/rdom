class String
  def titleize
    string = dup
    string.gsub(/\b('?[a-z])/) { $1.capitalize }
  end
end unless String.method_defined?(:titleize)
