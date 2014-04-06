module AresMUSH
  module Manage
    def self.can_manage?(actor)
      return actor.has_any_role?(Global.config["manage"]["roles"]["can_manage"])
    end
  end
end
