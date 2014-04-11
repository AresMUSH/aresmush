module AresMUSH
  module Utils
    class RenameCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      
      attr_accessor :target
      attr_accessor :name
            
      def initialize
        self.required_args = ['target']
        self.required_args = ['name']
        self.help_topic = 'rename'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("rename")
      end
      
      def crack!
        cmd.crack!(/(?<target>[^\=]+)\=(?<name>.+)/)
        self.target = cmd.args.target
        self.name = cmd.args.name
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end

      def handle
        find_result = VisibleTargetFinder.find(self.target, client)
        
        if (!find_result.found?)
          find_result = AnyTargetFinder.find(self.target, client)
        end
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target
        target.name = self.name
        target.save!
        client.emit t('manage.object_renamed', :name => self.name)
      end
    end
  end
end
