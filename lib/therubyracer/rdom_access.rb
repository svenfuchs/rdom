require 'v8/to'

module V8
  def self.js_property?(obj, name)
    obj.respond_to?(:js_property?) && obj.js_property?(name)
  end

  module To
    # got to use ruby_class, not class, therefor overwrite the whole thing
    def self.v8(value)
      case value
      when V8::Object
        value.instance_eval {@native}
      when String
        C::String::New(value.to_s)
      when Symbol
        C::String::NewSymbol(value.to_s)
      when Proc,Method
        template = C::FunctionTemplate::New() do |arguments|
          rbargs = []
          for i in 0..arguments.Length() - 1
            rbargs << To.rb(arguments[i])
          end
          V8::Function.rubycall(value, *rbargs)
        end
        return template.GetFunction()
      when ::Array
        C::Array::New(value.length).tap do |a|
          value.each_with_index do |item, i|
            a.Set(i, To.v8(item))
          end
        end
      when ::Hash
        C::Object::New().tap do |o|
          value.each do |key, value|
            o.Set(To.v8(key), To.v8(value))
          end
        end
      when ::Time
        C::Date::New(value)
      when ::Class
        Constructors[value].GetFunction().tap do |f|
          f.SetHiddenValue(C::String::NewSymbol("TheRubyRacer::RubyObject"), C::External::New(value))
        end
      when nil,Numeric,TrueClass,FalseClass, C::Value
        value
      else
        args = C::Array::New(1)
        args.Set(0, C::External::New(value))
        obj = Access[value.ruby_class].GetFunction().NewInstance(args)
        return obj
      end
    end
  end

  class NamedPropertyGetter
    def self.call(property, info)
      obj  = To.rb(info.This())
      name = To.rb(property)

      if V8.js_property?(obj, name)
        Function.rubycall(obj.method(name))
      elsif obj.respond_to?(name)
        To.v8(obj.method(name))
      elsif obj.respond_to?(:[])
        To.v8(obj[name])
      else
        C::Empty
      end
    end
  end

  class NamedPropertySetter
    def self.call(property, value, info)
      obj  = To.rb(info.This())
      name = To.rb(property)

      define_property(obj, name) unless obj.respond_to?("#{name}=")
      obj.send("#{name}=", To.rb(value))
      value
    end

    def self.define_property(obj, attr_name)
      (class << obj; self; end).class_eval do
        include RDom::Properties unless ruby_class.included_modules.include?(RDom::Properties)
        property attr_name
      end
    end
  end
end