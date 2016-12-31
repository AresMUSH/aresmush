module AresMUSH
  module Rooms
    class BuildCmd
      include CommandHandler

      attr_accessor :name
      attr_accessor :exit
      attr_accessor :return_exit
      
      def crack!
        # build <name>
        # build <name>=<outgoing exit>
        # build <name>=<outgoing exit>,<return exit>
        cmd.crack_args!(/(?<name>[^\=]+)\=?(?<exit>[^\,]*),?(?<return_exit>[^\,]*)/)
        self.name = cmd.args.name
        self.exit = cmd.args.exit
        self.return_exit = cmd.args.return_exit
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'build'
        }
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        room = AresMUSH::Room.create(:name => name)
        client.emit_success(t('rooms.room_created', :name => name))
        
        if (!self.exit.empty?)
          Rooms.open_exit(self.exit, enactor_room, room)
        end
        if (!self.return_exit.empty?)
          Rooms.open_exit(self.return_exit, room, enactor_room)
        end
        
        Rooms.move_to(client, enactor, room)
      end
    end
  end
end
