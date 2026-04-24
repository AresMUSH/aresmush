module AresMUSH
  module FS3Combat
    class CombatNpcsCmd
      include CommandHandler
      
      def handle
        types = Global.read_config("fs3combat", "npc_types")
        text = ""
        
        types.each do |name, values|
          text << "\n%xh#{name}%xn\n"
          values.each do |skill, rating|
            text << "     #{skill}: #{rating.to_s.ljust(3)}"
          end
        end
        
        template = BorderedDisplayTemplate.new text, t('fs3combat.npcs_title')
        client.emit template.render        
      end
    end
  end
end