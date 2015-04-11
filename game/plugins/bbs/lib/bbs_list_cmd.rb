module AresMUSH
  module Bbs
    class BbsListCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle       
        template = BoardListTemplate.new(client.char) 
        client.emit template.display
      end
    end
  end
end
