module AresMUSH
  class Character
    def on_roster?
      roster_registry ? true : false
    end
  end
end
