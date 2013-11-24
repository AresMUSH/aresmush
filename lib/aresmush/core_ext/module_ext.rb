# Borrowed from Rails:ActiveSupport
#-https://github.com/rails/rails/blob/2-1-stable/activesupport/lib/active_support/core_ext/module/attribute_accessors.rb

# Extends the module object with module and instance accessors for class attributes, 
# just like the native attr* accessors for instance attributes.
#
#  module AppConfiguration
#    mattr_accessor :google_api_key
#    self.google_api_key = "123456789"
#
#    mattr_accessor :paypal_url
#    self.paypal_url = "www.sandbox.paypal.com"
#  end
#
#  AppConfiguration.google_api_key = "overriding the api key!"
class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end

class Module  
  def mattr_reader(*syms)
    syms.each do |sym|
      next if sym.is_a?(Hash)
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end
        
        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
  end
  
  def mattr_writer(*syms)
    options = syms.extract_options!
    syms.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end
        
        def self.#{sym}=(obj)
          @@#{sym} = obj
        end
        
        #{"
        def #{sym}=(obj)
          @@#{sym} = obj
        end
        " unless options[:instance_writer] == false }
      EOS
    end
  end
  
  def mattr_accessor(*syms)
    mattr_reader(*syms)
    mattr_writer(*syms)
  end
end