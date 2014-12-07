module AresMUSH
  module Roles
    def self.valid_role?(name)
      all_roles.include?(name.downcase)
    end
  end
end