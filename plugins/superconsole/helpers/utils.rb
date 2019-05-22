module AresMUSH
  module SuperConsole
    def can_view_sheets(actor)
      return false if !actor
      actor.has_permission?("view_sheets")
    end
  end
end
