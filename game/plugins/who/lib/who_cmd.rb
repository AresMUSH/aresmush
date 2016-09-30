module AresMUSH
  module Who
    class WhoCmd
      include CommandHandler
      include CommandWithoutArgs
      include CommandWithoutSwitches
            
      def handle        
        online_chars = Global.client_monitor.logged_in.map { |client, char| char }
        template = WhoTemplate.new online_chars
        client.emit template.render
      end      
    end
  end
end
