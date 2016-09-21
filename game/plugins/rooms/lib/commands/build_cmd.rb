module AresMUSH
  module Rooms
    class BuildCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :name
      attr_accessor :exit
      attr_accessor :return_exit
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'build'
        super
      end
      
      def crack!
        # build <name>
        # build <name>=<outgoing exit>
        # build <name>=<outgoing exit>,<return exit>
        cmd.crack_args!(/(?<name>[^\=]+)\=?(?<exit>[^\,]*),?(?<return_exit>[^\,]*)/)
        self.name = cmd.args.name
        self.exit = cmd.args.exit
        self.return_exit = cmd.args.return_exit
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def handle
        room = AresMUSH::Room.create(:name => name)
        client.emit_success(t('rooms.room_created', :name => name))
        
        if (!self.exit.empty?)
          Rooms.open_exit(self.exit, client.room, room)
        end
        if (!self.return_exit.empty?)
          Rooms.open_exit(self.return_exit, room, client.room)
        end
        
        Rooms.move_to(client, client.char, room)
      end
    end
  end
end
