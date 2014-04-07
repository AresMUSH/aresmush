module AresMUSH
  module Rooms
    class LinkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :name
      attr_accessor :dest
      
      def initialize
        self.required_args = ['name', 'dest']
        self.help_topic = 'link'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("link")
      end
            
      def crack!
        cmd.crack!(/(?<name>[^\=]*)=?(?<dest>.*)/)
        self.name = trim_input(cmd.args.name)
        self.dest = trim_input(cmd.args.dest)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def handle
        find_result = ClassTargetFinder.find(self.dest, Room, client)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        dest = find_result.target
          
        find_result = VisibleTargetFinder.find(self.name, client)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target
        if (target.class != Exit)
          client.emit_failure(t('rooms.can_only_link_exits'))
          return
        end
        
        target.dest = dest
        target.save!
        client.emit_success t('rooms.exit_linked', :dest => dest.name)
      end
    end
  end
end
