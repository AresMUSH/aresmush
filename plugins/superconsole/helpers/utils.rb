module AresMUSH
  module SuperConsole
    def can_view_sheets(actor)
      return false if !actor
      actor.has_permission?("view_sheets")
    end
    def can_set_stats(actor)
      actor.has_permission?("manage_stats")
    end
  end
end
