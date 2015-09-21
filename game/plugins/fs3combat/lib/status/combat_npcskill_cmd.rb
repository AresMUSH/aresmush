module AresMUSH
  module FS3Combat
    class CombatNpcSkillCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :skill
      
      def initialize
        self.required_args = ['name', 'skill']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("skill")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)   
        self.name = cmd.args.arg1
        self.skill = cmd.args.arg2 ? cmd.args.arg2.to_i : 0
      end
      
      def check_skill
        return t('fs3combat.invalid_npc_skill') if self.skill < 1 || self.skill > 12
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client) do |combat, combatant|        
          if (combat.organizer != client.char)
            client.emit_failure t('fs3combat.only_organizer_can_do')
            return
          end
          if (!combatant.is_npc?)
            client.emit_failure t('fs3combat.skill_set_only_for_npcs')
            return
          end
          
          combatant.npc_skill = self.skill
          combatant.save
          client.emit_success t('fs3combat.npc_skill_set', :skill => self.skill, :name => self.name)
        end
      end
    
    end
  end
end