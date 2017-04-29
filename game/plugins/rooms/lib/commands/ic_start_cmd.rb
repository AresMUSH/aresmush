module AresMUSH
  module Rooms
    class ICStartCmd
      include CommandHandler

      attr_accessor :dest

      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.dest ],
          help: 'icstart'
        }
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        find_result = ClassTargetFinder.find(self.dest, Room, enactor)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        dest = find_result.target
          
        
        
        Game.master.update(ic_start_room: dest)
        client.emit_success t('rooms.ic_start_set', :dest => dest.name)
      end
    end
  end
end
