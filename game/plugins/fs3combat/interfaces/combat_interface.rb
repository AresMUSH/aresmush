module AresMUSH
  module FS3Combat
    def self.register_pose(char)
      return if !char.combatant
      char.combatant.posed = true
      char.combatant.save
    end
  end
end