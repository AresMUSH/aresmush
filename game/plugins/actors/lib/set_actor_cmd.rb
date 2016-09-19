module AresMUSH
  module Actors
    class SetActorCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :actor

      def initialize
        self.required_args = ['name', 'actor']
        self.help_topic = 'actors'
        super
      end
            
      def crack!
        if (cmd.args =~ /\=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.actor = titleize_input(cmd.args.arg2)
        else
          self.name = client.name
          self.actor = titleize_input(cmd.args)
        end
      end
      
      def check_can_set
        return nil if self.name == client.name
        return nil if Actors.can_set_actor?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        Actors.create_or_update_actor(client, self.name, self.actor)
        client.emit_success t('actors.actor_set')
      end
    end
  end
end
