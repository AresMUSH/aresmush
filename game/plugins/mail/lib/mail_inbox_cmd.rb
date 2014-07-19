module AresMUSH
  module Mail
    class MailInboxCmd
      include Plugin
      include PluginRequiresLogin
           
      def initialize
        Mail.build_renderers
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle        
        client.emit Mail.inbox_renderer.render(client)
      end
    end
  end
end
