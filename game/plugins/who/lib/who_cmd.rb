module AresMUSH
  module Who
    class WhoCmd
      include CommandHandler
      include CommandWithoutSwitches

      attr_accessor :search
      
      def crack!
        self.search = titleize_input(cmd.args)
      end
                  
      def handle        
        online_chars = Global.client_monitor.logged_in.map { |client, char| char }
        if (self.search)
          online_chars = online_chars.select { |char| char.name =~ /^#{self.search}/ }
        end
        template = WhoTemplate.new online_chars
        client.emit template.render
      end      
    end
  end
end
