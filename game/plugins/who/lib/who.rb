module AresMUSH
  module Who
    class WhoCmd
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = container.client_monitor
      end

      def want_command?(cmd)
        cmd.root_is?("who")
      end
      
      def want_anon_command?(cmd)
        cmd.root_is?("who")
      end
      
      def on_command(client, cmd)
        show_who(client)
      end
      
      def on_anon_command(client, cmd)
        show_who(client)
      end
      
      def show_who(client)
        logged_in = @client_monitor.clients.select { |c| c.logged_in? }
        who_list = WhoFormatter.format(logged_in, container)
        client.emit Formatter.perform_subs(who_list)
      end
    end
  end
end
