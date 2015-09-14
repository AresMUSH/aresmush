module AresMUSH
  module FS3Combat
    class CombatStanceCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :stance
      
      def initialize
        self.required_args = ['name', 'stance']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("stance")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.stance = titleize_input(cmd.args.arg2)
        else
          self.name = client.char.name
          self.stance = titleize_input(cmd.args)
        end
      end

      def check_stance
        stances = ['Banzai', 'Normal', 'Cautious', 'Evade', 'Cover']
        return t('fs3combat.invalid_stance') if !stances.include?(self.stance)
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client) do |combat, combatant|        
          combatant.stance = stance
          combatant.save
          message = t('fs3combat.stance_changed', :stance => self.stance, :name => self.name, :poss => combatant.poss_pronoun)
          combat.emit message, FS3Combat.npcmaster_text(name, client.char)
        end
      end
    end
  end
end