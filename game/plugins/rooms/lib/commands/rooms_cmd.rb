module AresMUSH
  module Rooms
    class RoomsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches

      attr_accessor :name
      
      def want_command?(client, cmd)
        cmd.root_is?("rooms")
      end
      
      def crack!
        self.name = trim_input(cmd.args)
      end

      # TODO - Validate permissions
      
      def handle
        if (self.name.nil?)
          rooms = Room.all
        else
          rooms = Room.where(:name_upcase => /#{self.name.upcase}/)
        end
        rooms = rooms.sort { |a,b| a.name_upcase <=> b.name_upcase}
        rooms = rooms.map { |r| "#{r.id} #{r.name}"}
        client.emit BorderedDisplay.list(rooms, t('rooms.room_directory'))
      end
    end
  end
end
