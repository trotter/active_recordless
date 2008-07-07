# ActiveRecordless
class Object
  def remove_class_method(meth)
    metaclass.send :remove_method, meth
  end

  def metaclass
    class << self; self; end
  end
end

class Module
  def replace_class_methods(mod)
    mod.instance_methods.each { |m| remove_class_method m }
    extend mod
  end

  def replace_and_store_class_methods(mod, name)
    @class_method_store ||= {}
    @class_method_store[name] = []
    mod.instance_methods.each do |m|
      if metaclass.method_defined?(m)
        metaclass.send :alias_method, "#{m}_#{name}", m
        @class_method_store[name] << m
        remove_class_method m
      end
    end
    extend mod
  end

  def replace_and_store_instance_methods(mod, name)
    @instance_method_store ||= {}
    @instance_method_store[name] = []
    mod.instance_methods.each do |m|
      if method_defined?(m)
        alias_method "#{m}_#{name}", m
        @instance_method_store[name] << m
        remove_method m
      end
    end
    include mod
  end

  def restore_class_methods(name)
  end

  def restore_instance_methods(name)
  end

  def replace_instance_methods(mod)
    mod.instance_methods.each { |m| remove_method m }
    include mod
  end
end

module ActiveRecordless
#  def self.included(base)
#    base.replace_class_methods ClassMethods
#    base.replace_instance_methods InstanceMethods
#  end

  def self.included(base)
    base.send :extend, DisconnectMethods
  end

  module DisconnectMethods
    def disconnect!
      replace_and_store_class_methods ClassMethods, :active_recordless_class
      replace_and_store_instance_methods InstanceMethods, :active_recordless_instance
    end

    def reconnect!
      restore_class_methods :active_recordless_class
      restore_instance_methods :active_recordless_instance
    end
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
