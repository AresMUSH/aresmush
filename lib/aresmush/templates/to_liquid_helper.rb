module AresMUSH
  module ToLiquidHelper

    # Provides a hash that includes every method on the object as a hash variable,
    # except of course the ones that inherit from Object.
    def to_liquid
      class_methods = methods
      common_methods = Object.instance_methods
      class_methods = class_methods.reject{|m| common_methods.include?(m) || m == :to_liquid}
      vars = {}
      class_methods.each do |m|
        vars["#{m}"] = send(m)
      end
      vars
    end
  end
end