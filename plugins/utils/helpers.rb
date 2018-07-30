module AresMUSH
  module Utils
    def self.can_access_notes?(actor)
      actor.has_permission?("manage_notes")
    end
  end
end