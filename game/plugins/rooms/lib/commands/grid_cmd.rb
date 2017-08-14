module AresMUSH
  module Rooms
    class GridCmd
      include CommandHandler

      attr_accessor :name, :x, :y
      
      def parse_args
        if (cmd.args =~ /=/)          
          self.name = cmd.args.before('=')
          grid_coords = cmd.args.after('=')
          if (grid_coords)
            self.x = trim_arg grid_coords.before('/')
            self.y = trim_arg grid_coords.after('/')
          end
        else
          args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)
          self.name = "here"
          self.x = trim_arg args.arg1
          self.y = trim_arg args.arg2
        end        
      end

      def required_args
        [ self.name ]
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        matched_rooms = Room.find_by_name_and_area self.name, enactor_room
        if (matched_rooms.count != 1)
          client.emit_failure matched_rooms.count == 0 ? t('db.object_not_found') : t('db.object_ambiguous')
          return
        end
        room = matched_rooms.first
        
        if (self.x.blank? || self.y.blank?)
          room.update(room_grid_x: nil)
          room.update(room_grid_y: nil)
          message = t('rooms.grid_cleared')
        else          
          room.update(room_grid_x: self.x)
          room.update(room_grid_y: self.y)
          message = t('rooms.grid_set')
        end
        client.emit_success message
      end
    end
  end
end
