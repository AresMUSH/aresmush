module AresMUSH
  module Actors
    class SetActorCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :actor

      def initialize
        self.required_args = ['name', 'actor']
        self.help_topic = 'actors'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("actor") && cmd.switch_is?("set")
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
      
      def handle
        if ((self.name != client.name) && !Actors.can_set_actor?(client.char))
          client.emit_failure(t('dispatcher.not_allowed'))
          return
        end
        
        Actors.create_or_update_actor(client, self.name, self.actor)
        client.emit_success t('actors.actor_set')
      end
    end
  end
end
