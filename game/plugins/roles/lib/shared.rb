module AresMUSH
  module Roles
    def self.all_roles
      Global.config['roles']['roles'].map { |r| r.downcase }
    end
    
    def self.valid_role?(name)
      all_roles.include?(name.downcase)
    end
  end
end