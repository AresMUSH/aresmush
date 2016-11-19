module AresMUSH
  module Who
    class WhereCmd
      include CommandHandler
      include CommandWithoutSwitches
      
      attr_accessor :search
      
      def crack!
        self.search = titleize_input(cmd.args)
      end
      
      def handle
        online_chars = Global.client_monitor.logged_in.map { |client, char| char }
        if (self.search)
          online_chars = online_chars.select { |char| char.name =~ /^#{search}/  }
        end
        template = WhereTemplate.new online_chars
        client.emit template.render
      end      
    end
  end
end
