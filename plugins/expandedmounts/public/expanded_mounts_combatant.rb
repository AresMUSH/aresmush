module AresMUSH
  class Combatant < Ohm::Model

    reference :riding, "AresMUSH::Mount"
    reference :passenger_on, "AresMUSH::Mount"

    def mount
      self.riding ? self.riding : self.passenger_on
    end

    def is_on_mount?
      self.riding || self.passenger_on
    end

  end
end