module AresMUSH
  module FS3Combat
    class CombatTeamCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :team
      
      def initialize
        self.required_args = ['name', 'team']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("team")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.team = trim_input(cmd.args.arg2).to_i
        else
          self.name = client.char.name
          self.team = trim_input(cmd.args).to_i
        end
      end

      def check_team
        return t('fs3combat.invalid_team') if self.team < 1 || self.team > 5
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client) do |combat, combatant|        
          combatant.team = team
          combatant.save
          message = t('fs3combat.team_set', :name => self.name, :team => self.team)
          combat.emit message, FS3Combat.npcmaster_text(name, client.char)
        end
      end
    end
  end
end