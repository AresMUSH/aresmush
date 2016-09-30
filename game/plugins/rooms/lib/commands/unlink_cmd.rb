module AresMUSH
  module Rooms
    class UnlinkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :name
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'unlink'
        super
      end
            
      def crack!
        self.name = trim_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
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
        
        target.dest = nil
        target.save!
        client.emit_success t('rooms.exit_unlinked')
      end
    end
  end
end
