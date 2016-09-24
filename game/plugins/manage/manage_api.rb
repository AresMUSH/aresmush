module AresMUSH
  module Manage
    module Api
      def self.can_manage_game?(char)
        return Manage.can_manage_game?(char)
      end
    end
  end
end