module AresMUSH
  module FS3Combat
    
    # You can define your own custom combat actions.
    # Each action must have an action handler derived from CombatAction
    # Register your actions in a hash of action switch (e.g., 'attack' for 'combat/attack') and action class.
    # For example, to register an action for 'combat/mindtrick' you would do:
    #   {
    #      'mindtrick' => MindTrickAction
    #   }
    def self.custom_actions
      {}
    end
    
    # Here you can do any custom processing that needs to happen at the end of each turn.
    # This happens BEFORE the regular processing, so that the character's luck spends, damage this turn, etc.
    # hasn't been reset yet.
    def self.custom_new_turn_reset(combatant)
    end
  end
end