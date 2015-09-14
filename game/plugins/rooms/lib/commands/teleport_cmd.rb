module AresMUSH
  module Rooms
    class TeleportCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :destination
      attr_accessor :names
      
      def initialize
        self.required_args = ['destination']
        self.help_topic = 'teleport'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("teleport")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        if (cmd.args.arg2.nil?)
          self.names = []
          self.destination = trim_input(cmd.args.arg1)
        else
          self.names = cmd.args.arg1.nil? ? [] : cmd.args.arg1.split(" ")
          self.destination = trim_input(cmd.args.arg2)
        end
      end
      
      def check_can_teleport
        return t('dispatcher.not_allowed') if !Rooms.can_teleport?(client.char)
        return nil
      end
      
      def handle
        room = find_destination
        if (room.nil?)
          client.emit_failure(t('rooms.invalid_teleport_destination'))
          return
        end
        
        targets = find_targets
        return if targets.empty?

        targets.each do |t|
          if (t[:client] != client && t[:client] != nil)
            t[:client].emit_ooc(t('rooms.you_are_teleported', :name => client.name))
          end
        
          Rooms.move_to(t[:client], t[:char], room)
        end
      end
      
      def find_destination
        find_result = ClassTargetFinder.find(self.destination, Character, client)
        if (find_result.found?)
          return find_result.target.room
        end
        
        find_result = ClassTargetFinder.find(self.destination, Room, client)
        if (find_result.found?)
          return find_result.target
        end
        
        matched_rooms = Room.where(:name_upcase => /#{self.destination.upcase}/)
        
        if (matched_rooms.empty? || matched_rooms.count > 1)
          return nil
        end
        return matched_rooms[0]
      end
      
      def find_targets
        if (self.names.empty?)
          target = { :client => client, :char => client.char }
          targets = [ target ]
        else
          targets = []
          self.names.each do |n|
            find_result = ClassTargetFinder.find(n, Character, client)
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
