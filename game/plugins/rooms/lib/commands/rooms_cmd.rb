module AresMUSH
  module Rooms
    class RoomsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches

      attr_accessor :name
      
      def crack!
        self.name = trim_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def handle
        if (self.name.nil?)
          objects = Room.all
        else
          objects = Room.where(:name_upcase => /#{self.name.upcase}/)
        end
        
        objects = objects.sort { |a,b| a.name_upcase <=> b.name_upcase}
        objects = objects.map { |r| "#{r.id} - #{r.room_type.ljust(3)} - #{r.name}"}
        client.emit BorderedDisplay.list(objects, t('rooms.room_directory'))
      end
    end
  end
end
