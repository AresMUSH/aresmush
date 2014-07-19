module AresMUSH
  module Bbs
    class BbsListCmd
      include Plugin
      include PluginRequiresLogin
           
      def initialize
        Bbs.build_renderers
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle        
        client.emit Bbs.board_list_renderer.render(client)
      end
    end
  end
end
