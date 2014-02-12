module AresMUSH
  module Who
    class WhoCmd
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor

        header_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/header.lq")
        char_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/character.lq")
        footer_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/footer.lq")
        @renderer = WhoRenderer.new(header_template, char_template, footer_template)
      end

      def want_command?(cmd)
        cmd.root_is?("who") || cmd.root_is?("where")
      end
      
      def on_command(client, cmd)
        logged_in = @client_monitor.logged_in_clients
        client.emit @renderer.render(logged_in)
      end      
    end
  end
end
