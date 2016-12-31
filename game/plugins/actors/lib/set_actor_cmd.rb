module AresMUSH
  module Actors
    class SetActorCmd
      include CommandHandler
      
      attr_accessor :name, :actor
      
      def crack!
        if (cmd.args =~ /\=/)
          cmd.crack_args!(ArgParser.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.actor = titleize_input(cmd.args.arg2)
        else
          self.name = enactor_name
          self.actor = titleize_input(cmd.args)
        end
      end

      def required_args
        {
          args: [self.name, self.actor],
          help: 'actors'
        }
      end
      
      def check_can_set
        return nil if self.name == enactor_name
        return nil if Actors.can_set_actor?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        Actors.create_or_update_actor(enactor, self.name, self.actor)
        client.emit_success t('actors.actor_set')
      end
    end
  end
end
