# ActiveRecordless
class Object
  def metaclass
    class << self; self; end
  end
end

class Module
  def metaclass_module_where_defined(meth)
    included_modules.detect { |mod| mod.metaclass.method_defined?(meth) }
  end

  def module_where_defined(meth)
    included_modules.detect { |mod| mod.method_defined?(meth) }
  end
end

module ActiveRecordless
  def self.included(base)
    ClassMethods.instance_methods.each do |m|
      begin
        base.metaclass.send :remove_method, m 
      rescue
        base.metaclass_module_where_defined(m).send :remove_method, m
      end
    end
    base.send(:extend, ClassMethods)
    InstanceMethods.instance_methods.each do |m|
      begin
        base.send :remove_method, m 
      rescue
        base.module_where_defined(m).send :remove_method, m
      end
    end
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def columns
      []
    end
  end

  module InstanceMethods
  end
end

class ActiveRecord::Base
  include ActiveRecordless
end

