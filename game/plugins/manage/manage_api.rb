module AresMUSH
  class Character
    def can_manage_game?
      Manage.can_manage_game?(self)
    end
  end

  module Manage
    module Api
      def self.reload_config
        Manage.reload_config
      end
    end
  end
end