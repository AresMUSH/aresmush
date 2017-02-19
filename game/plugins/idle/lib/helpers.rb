module AresMUSH
  module Idle
    def self.can_idle_sweep?(actor)
      actor.has_any_role?(Global.read_config("idle", "can_idle_sweep"))
    end

    def self.is_exempt?(actor)
      actor.has_any_role?(Global.read_config("idle", "idle_exempt"))
    end
        
    def self.active_chars
      base_list = Character.all
      base_list.select { |c| !(c.idled_out? || c.is_admin? || c.is_playerbit? || c.is_guest? || c.is_npc? )}
    end
    
  end
end