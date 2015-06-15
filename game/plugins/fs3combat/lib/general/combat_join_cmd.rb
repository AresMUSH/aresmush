module AresMUSH
  module FS3Combat
    class CombatJoinCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :names, :num
      
      def initialize
        self.required_args = ['names', 'num']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("join")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.names = cmd.args.arg1.nil? ? [] : titleize_input(cmd.args.arg1).split(" ")
          self.num = trim_input(cmd.args.arg2)
        else
          self.names = [ client.name ]
          self.num = titleize_input(cmd.args)
        end
      end
      
      def handle
        combat = FS3Combat.find_combat_by_number(client, self.num)
        return if !combat
        
        self.names.each do |n|
          add_to_combat(combat, n)
        end
      end
      
      def add_to_combat(combat, name)
        if FS3Combat.is_in_combat?(name)
          client.emit_failure t('fs3combat.already_in_combat', :name => name) 
          return
        end
        
        result = ClassTargetFinder.find(name, Character, client)
        
        type = Global.read_config("fs3combat", "default_type")
        combat.join(name, type, result.target)
        combat.save
        
        weapon = FS3Combat.combatant_type_stat(type, "weapon")
        if (weapon)
          specials = FS3Combat.combatant_type_stat(type, "weapon_specials")
          FS3Combat.set_weapon(client, name, weapon, specials)
        end
        
        armor = FS3Combat.combatant_type_stat(type, "armor")
        if (armor)
          FS3Combat.set_armor(client, name, armor)
        end
      end
    end
  end
end