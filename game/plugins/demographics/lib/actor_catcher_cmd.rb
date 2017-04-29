module AresMUSH

  module Demographics
    class ActorCatcherCmd
      include CommandHandler
      
      def handle
        client.emit_failure t('demographics.try_actor_search_or_set')
      end
    end
  end
end