module AresMUSH
  module Rooms
    class UnlinkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'unlink'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("unlink")
      end
            
      def crack!
        self.name = trim_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def handle
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
        
        target.dest = nil
        target.save!
        client.emit_success t('rooms.exit_unlinked')
      end
    end
  end
end
