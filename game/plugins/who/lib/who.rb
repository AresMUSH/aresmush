module AresMUSH
  module Who
    class WhoCmd
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor

        @header_template = read_template("header.lq")
        @char_template = read_template("character.lq")
        @footer_template = read_template("footer.lq")
      end

      def want_command?(cmd)
        cmd.root_is?("who")
      end
      
      def on_command(client, cmd)
        logged_in = @client_monitor.clients.select { |c| c.logged_in? }
        renderer = WhoRenderer.new(logged_in, @header_template, @char_template, @footer_template)
        client.emit renderer.render
      end
      
      def read_template(name)
        template = File.read(File.dirname(__FILE__) + "/../templates/#{name}")
        Template2.new(template)
      end
        
    end
  end
end
