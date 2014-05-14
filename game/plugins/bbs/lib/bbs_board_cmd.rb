module AresMUSH
  module Bbs
    class BbsBoardCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :board_name

      def initialize
        self.required_args = ['board_name']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch.nil? && (cmd.args !~ /[=\/]/)        
      end
      
      def crack!
        self.board_name = titleize_input(cmd.args)
      end
      
      def handle
        Bbs.with_a_board(self.board_name, client) do |board|  
          client.emit RendererFactory.board_renderer.render(board, client)
        end
      end
    end
  end
end