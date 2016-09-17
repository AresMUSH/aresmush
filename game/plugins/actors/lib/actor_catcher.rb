module AresMUSH

  module Actors
    class ActorsCatcherCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :page

      def want_command?(client, cmd)
        cmd.root_is?("actor") && !cmd.switch && cmd.args
      end

      
      def handle
        client.emit_failure t('actors.try_search_or_set')
      end
    end
  end
end
