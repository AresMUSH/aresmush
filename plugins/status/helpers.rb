module AresMUSH
  module Status
    def self.can_be_on_duty?(actor)
      actor.has_permission?("set_duty")
    end

    def self.can_manage_status?(actor)
      actor.has_permission?("manage_status")
    end
  end
end