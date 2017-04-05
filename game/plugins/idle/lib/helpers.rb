module AresMUSH
  module Idle
    def self.can_idle_sweep?(actor)
      actor.has_permission?("idle_sweep")
    end

    def self.is_exempt?(actor)
      actor.has_permission?("idle_exempt")
    end
        
    def self.active_chars
      base_list = Character.all
      base_list.select { |c| !(c.idled_out? || c.is_admin? || c.is_playerbit? || c.is_guest? || c.is_npc? )}
    end
    
    def self.idle_action_color(action)
    	case action
         when "Destroy"
           color = "%xh%xx"
         when "Warn"
           color = "%xh"
         when "Npc"
           color = "%xb"
         when "Dead"
           color = "%xh%xr"
         when "Gone"
           color = "%xh%xy"
         when "Roster"
           color = "%xh%xg"
         else
           color = "%xc"
       end
     end
    
  end
end