module AresMUSH
  module Rooms
    class LinkCmd
      include CommandHandler

      attr_accessor :name, :room_name, :move_source

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.room_name = trim_arg(args.arg2)
        self.move_source = cmd.switch_is?("source")
      end
      
      def required_args
        {
          args: [ self.name, self.room_name ],
          help: 'link'
        }
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        matched_rooms = Room.find_by_name_and_area self.room_name
        if (matched_rooms.count != 1)
          client.emit_failure matched_rooms.count == 0 ? t('db.object_not_found') : t('db.object_ambiguous')
          return
        end
        room = matched_rooms.first
          
        find_result = VisibleTargetFinder.find(self.name, enactor)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target
        if (target.class != Exit)
          client.emit_failure(t('rooms.can_only_link_exits'))
          return
        end
        
        if (self.move_source)
          client.emit_success t('rooms.exit_source_linked', :room => room.name)
          target.update(source: room)
          target.update(dest: enactor_room)
        else
          client.emit_success t('rooms.exit_linked', :room => room.name)
          target.update(dest: room)
        end
      end
    end
  end
end
