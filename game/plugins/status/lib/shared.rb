module AresMUSH
  module Status
    def self.can_be_on_duty?(actor)
      actor.has_any_role?(Global.read_config("status", "roles", "can_be_on_duty"))
    end
  end
end