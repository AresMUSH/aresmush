module AresMUSH
  module Who
    class WhereCmd
      include CommandHandler
      include CommandWithoutArgs
      include CommandWithoutSwitches
      
      def handle
        online_chars = Global.client_monitor.logged_in_clients.map { |c| c.char }
        template = WhereTemplate.new online_chars
        client.emit template.render
      end      
    end
  end
end
