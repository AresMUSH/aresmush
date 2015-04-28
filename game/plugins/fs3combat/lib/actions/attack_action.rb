module AresMUSH
  module FS3Combat
    class AttackAction < CombatAction
      field :mod, :type => Integer
      field :is_burst, :type => Boolean
      field :called_shot, :type => String
      
      def parse_args(args)
        self.is_burst = false
        self.called_shot = nil
        self.mod = 0
        
        if (args =~ /\//)
          target_names = args.before("/")
          parse_specials args.after("/").split(",")
        else
          target_names = args
        end
        
        parse_targets target_names
      end

      def parse_specials(specials)
        specials.each do |s|
          name = s.before(":")
          value = s.after(":")
          case InputFormatter.titleize_input(name)
          when "Called"
            self.called_shot = InputFormatter.titleize_input(value)
          when "Mod"
            self.mod = value.to_i
          when "Burst"
            self.is_burst = true
          else
            raise t('fs3combat.invalid_attack_special')
          end
        end
      end
      
      def check_specials
        # TODO: Check weapon permits burst fire
        # TODO: Check called shot location is valid for target
        # TODO: Check targets valid (no non-combatants)
        return nil
      end
      
      def print_action
        msg = t('fs3combat.attack_action_msg', :name => self.name, :target => self.target_names.join(", "))
        if (self.is_burst)
          msg << " #{t('fs3combat.attack_special_burst')}"
        end
        if (self.called_shot)
          msg << " #{t('fs3combat.attack_special_called', :location => self.called_shot)}"
        end
        if (self.mod != 0)
          msg << " #{t('fs3combat.attack_special_mod', :mod => self.mod)}"
        end
        msg
      end
      
      def print_action_short
        t('fs3combat.attack_action_msg_short', :target => self.target_names.join(","))
      end
      
      def resolve
        # TODO - Called shots and burst fire
        # TODO - Hitting cover
        # TODO - Armor
        messages = []
        self.targets.each do |t|
          messages << attack_target(t)
        end
        messages.join("%R%% ")
      end
      
      def attack_target(target)
        attack_roll = self.combatant.roll_attack(self.mod)
        defense_roll = target.roll_defense(self.combatant.weapon)
        
        if (attack_roll <= 0)
          message = t('fs3combat.attack_missed', :name => self.name, :target => target.name)
        elsif (defense_roll > attack_roll)
          message = t('fs3combat.attack_dodged', :name => self.name, :target => target.name)
        else
          hitloc = target.determine_hitloc(attack_roll - defense_roll)
          damage = target.determine_damage(hitloc, self.combatant.weapon)
          target.do_damage(damage, self.combatant.weapon, hitloc)
          message = t('fs3combat.attack_hits', 
            :name => self.name, 
            :target => target.name,
            :hitloc => hitloc,
            :damage => FS3Combat.display_severity(damage)) 
        end
        message
      end
    end
  end
end