module AresMUSH
  module Status
    def self.can_manage_status?(actor)
      actor.has_any_role?(Global.config["status"]["roles"]["can_manage_status"])
    end
  end
end