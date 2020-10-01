module AresMUSH
  module Idle
    def self.active_chars
      Character.all.select { |c| c.is_active? }
    end
  
  end
end