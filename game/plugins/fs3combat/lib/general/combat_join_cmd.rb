module AresMUSH
  module FS3Combat
    class CombatJoinCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :num
      
      def initialize
        self.required_args = ['name', 'num']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("join")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.num = trim_input(cmd.args.arg2)
        else
          self.name = client.name
          self.num = titleize_input(cmd.args)
        end
      end
      
      def check_not_already_in_combat
        return t('fs3combat.already_in_combat', :name => self.name) if FS3Combat.is_in_combat?(self.name)
        return nil
      end
      
      def handle
        combat = FS3Combat.find_combat_by_number(client, self.num)
        return if !combat
        
        result = ClassTargetFinder.find(self.name, Character, client)
        
        type = Global.config["fs3combat"]["default_type"]
        combat.join(self.name, type, result.target)
        combat.save
        
        type_config = Global.config["fs3combat"]["combatant_types"][type]
        weapon = type_config["weapon"]
        if (weapon)
          specials = type_config["weapon_specials"]
          FS3Combat.set_weapon(client, self.name, weapon, specials)
        end
        
        if (type_config["armor"])
          FS3Combat.set_armor(client, self.name, type_config["armor"])
        end
        
      end
    end
  end
end