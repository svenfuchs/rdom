require 'rubygems'
require 'johnson'

class Window
  def runtime
    @runtime ||= Johnson::Runtime.new.tap do |runtime|
      runtime['console'] = Class.new { def log(line); p line; end }.new
    end
  end

  def evaluate(script, file = nil, line = nil)
    runtime.evaluate(script, file, line, self, self)
  end
end

window = Window.new

window.evaluate('console.log("foo");')
window.evaluate('console.log("foo");') # Johnson::Error: console.log is not a function