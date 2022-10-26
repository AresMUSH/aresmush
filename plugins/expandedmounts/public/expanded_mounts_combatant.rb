module AresMUSH
  class Combatant < Ohm::Model

    reference :riding, "AresMUSH::Mount"
    reference :passenger_on, "AresMUSH::Mount"
    attribute :expanded_mount_type

    def mount
      self.riding ? self.riding : self.passenger_on
    end

    def is_on_mount?
      if self.riding || self.passenger_on
        return true
      else
        return false
      end
    end

    def is_mount?
      false
    end

    def bonded
      !self.is_npc? ? self.associated_model.bonded : nil
    end

  end
end