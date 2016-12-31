module AresMUSH
  module Actors
    class SetActorCmd
      include CommandHandler
      
      attr_accessor :name, :actor
      
     
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.actor = titlecase_arg(args.arg2)
        else
          self.name = enactor_name
          self.actor = titlecase_arg(cmd.args)
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
