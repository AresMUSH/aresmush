module AresMUSH
  class CombatAction
    
    attr_accessor :target_names, :combatant, :targets

    def initialize(combatant)
      self.combatant = combatant
      self.targets = []
    end
    
    def name
      self.combatant.name
    end
    
    def combat
      self.combatant.combat
    end
    
    def self.crack_helper(enactor, cmd)
      if (cmd.args =~ /\=/)
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        name = InputFormatter.titleize_input(cmd.args.arg1)
        action_args = cmd.args.arg2
      else
        name = enactor.name
        action_args = cmd.args
      end
      {
        :name => name,
        :action_args => action_args
      }
    end
    
    def error_check
      self.methods.grep(/^check_/).sort.each do |m|
        error = send m
        if (error)
          return error
        end
      end
      return nil
    end
    
    def check_can_act
      return t('fs3combat.cannot_act_while_koed') if self.combatant.is_ko
      return nil
    end
    
    def check_valid_targets
      self.targets.each do |t|
        return t('fs3combat.cant_target_noncombatant', :name => t.name) if t.is_noncombatant?
      end
      return nil
    end
    
    def parse_targets(name_string)
      self.target_names = name_string.split(" ").map { |n| InputFormatter.titleize_input(n) }
      self.targets = []
      self.target_names.each do |name|
        target = self.combat.find_combatant(name)
        raise t('fs3combat.not_in_combat', :name => name) if !target
        self.targets << target
      end
    end
    
    def print_target_names
      self.target_names.join(" ")
    end
  end 
end