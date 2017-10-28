module AresMUSH
  module Idle
    def self.active_chars
      base_list = Character.all
      base_list.select { |c| !(c.idled_out? || c.is_admin? || c.is_playerbit? || 
        c.is_guest? || c.is_npc? || c.on_roster? )}
    end
  end
end