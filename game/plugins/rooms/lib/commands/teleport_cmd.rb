module AresMUSH
  module Rooms
    class TeleportCmd
      include CommandHandler

      attr_accessor :destination
      attr_accessor :names
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        if (!args.arg2)
          self.names = []
          self.destination = trim_arg(args.arg1)
        else
          self.names = split_arg(args.arg1)
          self.destination = trim_arg(args.arg2)
        end
      end
      
      def required_args
        {
          args: [ self.destination ],
          help: 'teleport'
        }
      end
      
      def check_can_teleport
        return t('dispatcher.not_allowed') if !Rooms.can_teleport?(enactor)
        return nil
      end
      
      def handle
        matched_rooms = find_destination
        if (matched_rooms.count == 0)
          client.emit_failure t('rooms.invalid_teleport_destination')
          return
        end
        
        if (matched_rooms.count > 1)
          client.emit_failure t('db.object_ambiguous')
          return
        end
        
        room = matched_rooms[0]
        
        targets = find_targets
        return if targets.empty?

        targets.each do |t|
          if (t[:client] != client && t[:client] != nil)
            t[:client].emit_ooc(t('rooms.you_are_teleported', :name => enactor_name))
          end
        
          Rooms.move_to(t[:client], t[:char], room)
        end
      end
      
      def find_destination
        find_result = ClassTargetFinder.find(self.destination, Character, enactor)
        if (find_result.found?)
          return [find_result.target.room]
        end
        
        find_result = ClassTargetFinder.find(self.destination, Room, enactor)
        if (find_result.found?)
          return [find_result.target]
        end
        
        matched_rooms = Room.all.select { |r| format_room_name_for_match(r) =~ /#{self.destination.upcase}/ }
                
        return matched_rooms
      end
      
      def format_room_name_for_match(room)
        if (self.destination =~ /\//)
          return "#{room.area}/#{room.name}".upcase
        else
          return room.name.upcase
        end
      end
      
      def find_targets
        if (self.names.empty?)
          target = { :client => client, :char => enactor }
          targets = [ target ]
        else
          targets = []
          self.names.each do |n|
            find_result = ClassTargetFinder.find(n, Character, enactor)
            if (!find_result.found?)
              client.emit_failure t('rooms.cant_find_that_to_teleport', :name => n)
              return []
            end
            target = { :char => find_result.target, :client => find_result.target.client }
            targets << target
          end
        end
        targets
      end
    end
  end
end
