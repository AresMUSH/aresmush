module AresMUSH

  module FS3Skills
    class SetHooksCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :hooks

      def initialize
        self.required_args = ['hooks']
        self.help_topic = 'abilities'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("hook")
      end

      def crack!
        self.hooks = cmd.args
      end
      
      def handle
        client.char.fs3_hooks = self.hooks
        client.char.save
        
        client.emit_success t('fs3skills.hooks_set')
      end
    end
  end
end
