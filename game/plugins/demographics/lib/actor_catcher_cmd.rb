module AresMUSH

  module Demographics
    class ActorCatcherCmd
      include CommandHandler

      def help
        "`actors` - Show taken actors.\n" +
        "`actor/set <name>` - Set your actor.  Leave blank to clear it."
      end      

      def handle
        client.emit_failure t('demographics.try_actor_search_or_set')
      end
    end
  end
end