module AresMUSH

  module Actors
    class ActorsCatcherCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :page

      def handle
        client.emit_failure t('actors.try_search_or_set')
      end
    end
  end
end
