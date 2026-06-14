module AresMUSH
  module FS3Combat
    class CombatNpcsCmd
      include CommandHandler
      
      def handle
        types = Global.read_config("fs3combat", "npc_types")
        text = ""
        
        types.each do |name, values|
          text << "\n%xh#{name}%xn"
          values.each_with_index do |(skill, rating), index|
            separator = index % 3 == 0 ? "%R" : ""
            text << "#{separator}#{skill.ljust(21, '.')}#{rating.to_s.ljust(5)}"
          end
          text << "\n"
        end
        
        template = BorderedDisplayTemplate.new text, t('fs3combat.npcs_title')
        client.emit template.render        
      end
    end
  end
end