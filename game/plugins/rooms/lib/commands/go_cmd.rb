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
      
      def handle
        exit = client.room.exits.select { |e| e.name_upcase == self.destination.upcase }.first
        
        if (exit.nil? || exit.dest.nil?)
          client.emit_failure(t("rooms.cant_go_that_way"))
          return
        end
        Rooms.move_to(client, client.char, exit.dest)
      end
    end
  end
end
