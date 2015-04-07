module AresMUSH
  module Who
    class WhereCmd
      include Plugin
      include PluginWithoutArgs
      include PluginWithoutSwitches
      
      def want_command?(client, cmd)
        cmd.root_is?("where")
      end
      
      def handle
        online_chars = Global.client_monitor.logged_in_clients.map { |c| c.char }
        template = WhereTemplate.new online_chars
        client.emit template.display
      end      
    end
  end
end
