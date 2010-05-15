class String
  def titleize
    string = dup
    string[0, 1].upcase + string[1..-1]
  end
end unless String.method_defined?(:titleize)
