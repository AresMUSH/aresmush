module AresMUSH
  module Rooms
    class LinkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :name
      attr_accessor :dest
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name', 'dest']
        self.help_topic = 'link'
        super
      end
            
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.dest = trim_input(cmd.args.arg2)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        find_result = ClassTargetFinder.find(self.dest, Room, enactor)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        dest = find_result.target
          
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
        
        target.dest = dest
        target.save!
        client.emit_success t('rooms.exit_linked', :dest => dest.name)
      end
    end
  end
end
