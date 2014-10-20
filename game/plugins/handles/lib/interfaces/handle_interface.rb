module AresMUSH
  module Handles
    def self.handle_name_valid?(name)
      return false if name.blank?
      name.start_with?("@")
    end
  end
end