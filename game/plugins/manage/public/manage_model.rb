module AresMUSH
  class Character
    def can_manage_game?
      Manage.can_manage_game?(self)
    end
  end
end