module AresMUSH
  module Bbs
    class BbsBoardCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include TemplateFormatters
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        return false if !cmd.root_is?("bbs")
        return false if !cmd.switch.nil?
        return false if cmd.args.nil?
        return false if cmd.args =~ /[=\/]/
        true
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        Bbs.with_a_board(self.name, client) do |board|  
          client.emit RendererFactory.board_renderer.render(board, client)
        end
      end
      
      
    end
  end
end