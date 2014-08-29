module AresMUSH
  module Manage
    class ExamineCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      include PluginRequiresLogin
      
      attr_accessor :target
      
      def initialize
        self.required_args = ['target']
        self.help_topic = 'examine'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("examine")
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end

      def handle
        find_result = AnyTargetFinder.find(self.target, client)
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target

        if (!Manage.can_manage_object?(client.char, target))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end

        client.emit BorderedDisplay.text("#{target.to_json}")
      end
    end
  end
end
