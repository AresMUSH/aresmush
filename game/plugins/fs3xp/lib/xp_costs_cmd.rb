module AresMUSH

  module FS3XP
    class XpCostsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("xp") && cmd.switch_is?("costs")
      end
      
      def handle
        lang_cost = Global.read_config("fs3xp", "lang_cost")
        ability_cost = Global.read_config("fs3xp", "skill_costs")
        max_xp_hoard = Global.read_config("fs3xp", "max_xp_hoard")
        days_between_xp_raises = Global.read_config("fs3xp", "days_between_xp_raises")
        
        text = "%xh#{t('fs3xp.lang_cost_title')}%xn #{lang_cost}"
        text << "%R%R"
        text << "%xh#{t('fs3xp.ability_costs_title')}%xn"
        ability_cost.each do |rating, cost|
          title = "#{rating}".ljust(6)
          text << "%R  %xh#{title}%xn#{cost}"
        end
        
        text << "%R%R"
        text << "%xh#{t('fs3xp.max_xp_hoard')}%xn #{max_xp_hoard}"
        text << "%R%R"
        text << "%xh#{t('fs3xp.days_between_xp_raises')}%xn #{days_between_xp_raises}"
          
        client.emit BorderedDisplay.text text, t('fs3xp.costs_title')
      end
    end
  end
end
