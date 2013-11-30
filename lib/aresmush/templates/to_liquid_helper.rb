module AresMUSH
  module ToLiquidHelper

    # Provides a hash that includes every method on the object as a hash variable,
    # except of course the ones that inherit from Object.
    def self.to_liquid
      methods = data.methods
      common_methods = Object.instance_methods
      methods = methods.reject{|m| common_methods.include?(m)}
      vars = {}
      methods.each do |m|
        vars["#{m}"] = data.send(m)
      end
    end
  end
end