module AresMUSH
  module Roles
    def self.valid_role?(name)
      all_roles.include?(name.downcase)
    end
    
    def self.chars_with_role(name)
      Character.where(:roles.in => [ name ]).all
    end
  end
end