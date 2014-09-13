module AresMUSH
  module Actors
    class DeleteActorCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'actors'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("actor") && cmd.switch_is?("delete")
      end

      def crack!
        self.name = trim_input(cmd.args)
      end
      
      def check_is_allowed
        return t('dispatcher.not_allowed') if !Actors.can_set_actor?(client.char)
        return nil
      end
      
      def handle
        actor = ActorRegistry.all.select { |a| a.charname.upcase == self.name.upcase }
        
        if (actor.empty?)
          client.emit_failure t('actors.actor_not_found')
        else
          actor[0].destroy
          client.emit_success t('actors.actor_deleted')
        end
      end
    end
  end
end
