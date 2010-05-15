Dir["#{File.expand_path('..', __FILE__)}/**/*_test.rb"].each do |file|
  require file # if file =~ /event|html|jquery|location/
end