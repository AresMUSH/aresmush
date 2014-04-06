module AresMUSH
  module Rooms
    class GoCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :destination
      
      def initialize
        self.required_args = ['destination']
        self.help_topic = 'go'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("go")
      end
      
      def crack!
        self.destination = trim_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def handle
        exit = client.room.exits.find_by_name_upcase(self.destination.upcase)
        
        if (exit.nil? || exit.dest.nil?)
          client.emit_failure(t("rooms.cant_go_that_way"))
          return
        end
        Rooms.move_to(client, client.char, exit.dest)
      end
    end
  end
end
