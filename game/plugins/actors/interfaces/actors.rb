module AresMUSH
  class Character
    def actor
      self.actor_registry.nil? ? t('actors.actor_not_set') : self.actor_registry.actor
    end
  end
end