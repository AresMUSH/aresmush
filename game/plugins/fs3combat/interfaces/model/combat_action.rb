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
      # TODO - check not KO'd
      return nil
    end
    
    def check_valid_targets
      # TODO: Check targets valid (no non-combatants)
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