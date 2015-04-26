module AresMUSH
  module FS3Combat
    class AttackAction
      attr_accessor :combatant, :target, :called, :is_burst, :mod, :target_combatant
      
      def initialize(combatant, args)
        self.combatant = combatant
        self.is_burst = false
        self.called = nil
        self.mod = 0
        
        if (args =~ /\//)
          self.target = InputFormatter.titleize_input(args.before("/"))
          parse_specials args.after("/").split(",")
        else
          self.target = InputFormatter.titleize_input(args)
        end
        
        self.target_combatant = self.combat.find_combatant(self.target)
      end

      def parse_specials(specials)
        specials.each do |s|
          name = s.before(":")
          value = s.after(":")
          case InputFormatter.titleize_input(name)
          when "Called"
            self.called = InputFormatter.titleize_input(value)
          when "Mod"
            self.mod = value.to_i
          when "Burst"
            self.is_burst = true
          else
            raise t('fs3combat.invalid_attack_special')
          end
        end
      end
      
      def check_action
        # TODO: Check weapon permits burst fire
        # TODO: Check called shot location is valid for target

        # TODO: Check target is valid
        if (!self.target_combatant)
          return t('fs3combat.not_a_valid_target', :name => self.target)
        end
        return nil
      end
      
      def name
        self.combatant.name
      end
      
      def combat
        self.combatant.combat
      end
      
      def print_action
        msg = t('fs3combat.attack_action_msg', :name => self.name, :target => self.target)
        if (self.is_burst)
          msg << " #{t('fs3combat.attack_special_burst')}"
        end
        if (self.called)
          msg << " #{t('fs3combat.attack_special_called', :location => self.called)}"
        end
        if (self.mod != 0)
          msg << " #{t('fs3combat.attack_special_mod', :mod => self.mod)}"
        end
        msg
      end
      
      def resolve
        # TODO - Called shots and burst fire
        # TODO - Stance mods
        # TODO - Hitting cover
        # TODO - Armor
        
        attack_roll = self.combatant.roll_attack(self.mod)
        defense_roll = self.target_combatant.roll_defense(self.combatant.weapon)
        
        if (attack_roll <= 0)
          message = t('fs3combat.attack_missed', :name => self.name, :target => self.target)
        elsif (defense_roll > attack_roll)
          message = t('fs3combat.attack_dodged', :name => self.name, :target => self.target)
        else
          # TODO - Determine damage and hitloc
          # TODO - Inflict damage
          damage = "D"
          hitloc = "H"
          message = t('fs3combat.attack_hits', 
            :name => self.name, 
            :target => self.target,
            :hitloc => hitloc,
            :damage => damage) 
        end
        [message]
      end
    end
  end
end