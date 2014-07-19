module AresMUSH
  module Manage
    class AnnounceCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :message
      
      def initialize
        self.required_args = ['message']
        self.help_topic = 'announce'
        super
      end
      
      def crack!
        self.message = cmd.args
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("announce")
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end
      
      def handle
        Global.client_monitor.emit_all t('manage.announce', :name => client.name, :message => self.message)
      end
    end
  end
end