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
          self.names = list_arg(args.arg1)
          self.destination = trim_arg(args.arg2)
        end
      end
      
      def required_args
        [ self.destination ]
      end
      
      def check_can_teleport
        return t('dispatcher.not_allowed') if !Rooms.can_teleport?(enactor)
        return nil
      end
      
      def handle
        matched_rooms = Rooms.find_destination(self.destination, enactor, true)
        if (matched_rooms.count == 0)
          room_names = Room.all.select { |r| r.name_upcase =~ /#{self.destination.upcase}/ }.map { |r| r.name_and_area }.join(', ')
          client.emit_failure t('rooms.invalid_teleport_destination', :rooms => room_names)
          return
        end
        
        if (matched_rooms.count > 1)
          room_names = matched_rooms.map { |r| r.name_and_area }.join(', ')
          client.emit_failure t('rooms.multiple_rooms_found', :rooms => room_names)
          return
        end
        
        room = matched_rooms[0]
        
        if (room.scene && !Scenes.can_read_scene?(enactor, room.scene))
          client.emit_failure t('rooms.cant_teleport_private_scene')
          return
        end
        
        targets = find_targets
        return if targets.empty?

        targets.each do |t|
          if (t[:client] != client && t[:client] != nil)
            t[:client].emit_ooc(t('rooms.you_are_teleported', :name => enactor_name))
          end
        
          Rooms.move_to(t[:client], t[:char], room)
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
            target = { :char => find_result.target, :client => Login.find_client(find_result.target) }
            targets << target
          end
        end
        targets
      end
    end
  end
end
