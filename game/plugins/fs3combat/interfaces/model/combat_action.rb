module AresMUSH
  class CombatAction
    include SupportingObjectModel
    
    field :target_names, :type => Array, :default => []

    belongs_to :combatant, :class_name => 'AresMUSH::Combatant', :inverse_of => :action
    has_and_belongs_to_many :targets, :class_name => 'AresMUSH::Combatant', :inverse_of => :targeted_by_actions
    
    def name
      self.combatant.name
    end
    
    def combat
      self.combatant.combat
    end
    
    def self.crack_helper(client, cmd)
      if (cmd.args =~ /\=/)
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        name = InputFormatter.titleize_input(cmd.args.arg1)
        action_args = cmd.args.arg2
      else
        name = client.name
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
        if (!error.nil?)
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
      self.target_names = name_string.split(",").map { |n| InputFormatter.titleize_input(n) }
      self.targets = []
      self.target_names.each do |name|
        target = self.combat.find_combatant(name)
        raise t('fs3combat.not_in_combat', :name => name) if !target
        self.targets << target
      end
    end
  end 
end