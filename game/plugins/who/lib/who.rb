module AresMUSH
  module Who
    class WhoCmd
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end

      def want_command?(cmd)
        cmd.root_is?("who")
      end
      
      def on_command(client, cmd)
        logged_in = @client_monitor.clients.select { |c| c.logged_in? }
        who_list = WhoRenderer.render(logged_in)
        client.emit who_list
      end
    end
  end
end
