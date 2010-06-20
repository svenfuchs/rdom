require 'v8/to'

module V8
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
  
  def self.callable_name(obj, name)
    camel_name = To.camel_case(name)
    perl_name = To.perl_case(name)

    if V8.callable?(obj, camel_name)
      camel_name
    elsif V8.callable?(obj, perl_name)
      perl_name
    end
  end
  
  def self.callable?(obj, name)
    obj.respond_to?(name) || obj.respond_to?(:js_property?)
  end
    
  class NamedPropertyGetter
    def self.call(property, info)
      obj = To.rb(info.This())

      name = To.rb(property)
      method_name = V8.callable_name(obj, name)
      
      if obj.respond_to?(:js_property?) && obj.js_property?(method_name)
        Function.rubycall(obj.method(method_name))
      elsif obj.respond_to?(method_name)
        To.v8(obj.method(method_name))
      else
        C::Empty
      end
    end
  end

  class NamedPropertySetter
    def self.call(property, value, info)
      obj = To.rb(info.This())
      
      name = To.rb(property)
      method_name = V8.callable_name(obj, name)

      if method_name
        camel_name = To.camel_case(name)
        unless obj.respond_to?(camel_name + '=')
          (class << obj; self; end).class_eval do
            attr_accessor camel_name
            include RDom::Properties unless ruby_class.included_modules.include?(RDom::Properties)
            properties name
          end
        end
        obj.send(camel_name + '=', To.rb(value))
      else
         C::Empty
      end
    end
  end
end