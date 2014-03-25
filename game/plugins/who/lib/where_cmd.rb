require 'erubis'

module AresMUSH
  module Who
    class WhereCmd
      include AresMUSH::Plugin

      # Validators
      no_args
      no_switches
      
      def after_initialize
        @renderer =  TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/where.erb")
      end

      def want_command?(client, cmd)
        cmd.root_is?("where")
      end
      
      def handle
        logged_in = Global.client_monitor.logged_in_clients
        clients = logged_in.map { |c| WhoClientData.new(c) }
        data = WhoData.new(clients)
        client.emit @renderer.render(data)
      end      
    end
  end
end
