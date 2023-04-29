module AresMUSH
  module Rooms
    class RoomStarredCmd
      include CommandHandler

      attr_accessor :option
            
      def parse_args
        self.option = OnOffOption.new(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        enactor_room.update(room_starred: self.option.is_on?)
        if (self.option.is_on?)
          client.emit_ooc t('rooms.starred_set')
        else
          client.emit_ooc t('rooms.starred_cleared')
        end
      end
    end
  end
end
