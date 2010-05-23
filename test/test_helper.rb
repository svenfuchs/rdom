$: << File.expand_path('../../lib', __FILE__)
$: << File.expand_path('../../vendor/css_parser/lib', __FILE__)

require 'rubygems'
require 'test/unit'
require 'webmock'
require 'rdom'

module TestDeclarative
  def self.included(base)
    base.class_eval do
      def self.test(name, *args, &block)
        test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
        defined = instance_method(test_name) rescue false
        raise "#{test_name} is already defined in #{self}" if defined
        if block_given?
          define_method(test_name, &block)
        else
          define_method(test_name) do
            flunk "No implementation provided for #{name}"
          end
        end
      end
    end
  end
end

Test::Unit::TestCase.send(:include, TestDeclarative)

class Test::Unit::TestCase
  include WebMock

  def stub_get(path, body)
    stub_request(:any, "http://example.org/#{path}").to_return(:body => body)
  end
end