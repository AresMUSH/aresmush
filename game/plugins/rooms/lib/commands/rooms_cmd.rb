module AresMUSH
  module Rooms
    class RoomsCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        if (!self.name)
          objects = Room.all
        else
          objects = Room.all.select { |r| r.name_upcase =~ /#{self.name.upcase}/ }
        end
        
        objects = objects.sort { |a,b| a.name_upcase <=> b.name_upcase}
        objects = objects.map { |r| "#{r.id} - #{r.room_type.ljust(3)} - #{r.name}"}
        client.emit BorderedDisplay.list(objects, t('rooms.room_directory'))
      end
    end
  end
end
