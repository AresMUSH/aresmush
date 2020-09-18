module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
def handle
  char = Character.find_one_by_name('Aliana')
  char.update(race: "Demon")
  client.emit " #{char.name} updated!"
end

    end
  end
end
