module AresMUSH
  class Character
    def actor
      self.actor_registry ? self.actor_registry.actor : t('actors.actor_not_set')
    end
  end
end