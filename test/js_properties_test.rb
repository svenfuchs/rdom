require File.expand_path('../test_helper', __FILE__)

# require 'webmock/test_unit'
require 'v8'
require 'therubyracer/rdom_access'
require 'rdom/properties'

Module.send(:include, RDom::Properties)

class JavascriptTest < Test::Unit::TestCase
  module Element
    properties :tagName
    
    def tagName
      'tag name'
    end
  end
  
  class Node # a la Nokogiri::XML::Node
    include Element
    property :nodeName
  end
  
  attr_reader :js, :node

  def setup
    @node = Node.new
    @js = V8::Context.new { |js| js['node'] = node }
  end
  
  test 'property defined on the class' do
    assert node.property?(:nodeName)
  end
  
  test 'property defined on a module included to the class' do
    assert node.property?(:tagName)
  end

  test 'property defined on the meta class' do
    (class << node; self; end).class_eval { property :foo }
    assert node.property?(:foo)
  end
end