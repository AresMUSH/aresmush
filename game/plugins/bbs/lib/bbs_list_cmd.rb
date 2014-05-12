module AresMUSH
  module Bbs
    class BbsListCmd
      include Plugin
      include PluginRequiresLogin
           
      def initialize
        RendererFactory.build_renderers
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle        
        client.emit RendererFactory.board_list_renderer.render(client)
      end
    end
  end
end
