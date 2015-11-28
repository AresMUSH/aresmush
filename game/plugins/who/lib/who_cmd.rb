module AresMUSH
  module Who
    class WhoCmd
      include CommandHandler
      include CommandWithoutArgs
      include CommandWithoutSwitches
      
      def want_command?(client, cmd)
        cmd.root_is?("who")
      end
      
      def handle        
        online_chars = Global.client_monitor.logged_in_clients.map { |c| c.char }
        template = WhoTemplate.new online_chars, client
        template.render
      end      
    end
  end
end
