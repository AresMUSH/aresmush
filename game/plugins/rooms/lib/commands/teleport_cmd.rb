module AresMUSH
  module Rooms
    class TeleportCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :destination
      attr_accessor :name
      
      def initialize
        self.required_args = ['destination']
        self.help_topic = 'teleport'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("teleport")
      end
      
      def crack!
        cmd.crack!(/(?<name_or_dest>[^\=]*)=?(?<dest>.*)/)
        if (cmd.args.dest.empty?)
          self.name = nil
          self.destination = trim_input(cmd.args.name_or_dest)
        else
          self.name = trim_input(cmd.args.name_or_dest)
          self.destination = trim_input(cmd.args.dest)
        end
      end
      
      def check_can_teleport
        return t('dispatcher.not_allowed') if !Rooms.can_teleport?(client.char)
        return nil
      end
      
      def handle
        targets = find_targets
        if (targets[:char].nil?)
          client.emit_failure(t('db.object_not_found'))
          return
        end
        
        room = find_destination
        if (room.nil?)
          client.emit_failure(t('rooms.invalid_teleport_destination'))
          return
        end
        
        if (targets[:client] != client)
          targets[:client].emit_ooc(t('rooms.you_are_teleported', :name => client.name))
        end
        
        Rooms.move_to(targets[:client], targets[:char], room)
      end
      
      def find_destination
        find_result = ClassTargetFinder.find(self.destination, Character)
        if (find_result.found?)
          return find_result.target.room
        end
        find_result = ClassTargetFinder.find(self.destination, Room)
        if (find_result.found?)
          return find_result.target
        end
        return nil
      end
      
      def find_targets
        if (self.name.nil?)
          return { :client => client, :char => client.char }
        else
          find_result = ClassTargetFinder.find(self.name, Character)
          if (find_result.found?)
            return { :char => find_result.target, :client => Global.client_monitor.find_client(find_result.target) }
          else
            return { :char => nil, :client => nil }
          end
        end
      end
    end
  end
end
