module AresMUSH

  module Idle
    class LastWillCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :will

      def initialize
        self.required_args = ['will']
        self.help_topic = 'lastwill'
        super
      end      
      
      def want_command?(client, cmd)
        cmd.root_is?("lastwill")
      end
      
      def crack!
        self.will = cmd.args
      end
      
      def handle
        client.char.lastwill = self.will
        client.char.save!
        client.emit_success t('idle.lastwill_set')
      end
    end
  end
end
