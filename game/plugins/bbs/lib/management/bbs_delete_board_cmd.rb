module AresMUSH
  module Bbs
    class BbsDeleteBoardCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("deleteboard")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Bbs.can_manage_bbs?(client.char)
        return nil
      end
      
      def handle
        Bbs.with_a_board(self.name, client) do |board|
          client.program = { :delete_bbs => board }
          client.emit t('bbs.board_confirm_delete', :board => board.name)
        end
      end
    end
  end
end
