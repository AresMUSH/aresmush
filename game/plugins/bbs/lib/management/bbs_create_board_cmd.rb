module AresMUSH
  module Bbs
    class BbsCreateBoardCmd
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
        cmd.root_is?("bbs") && cmd.switch_is?("createboard")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Bbs.can_manage_bbs?(client.char)
        return nil
      end
      
      def check_board_exists
        return t('bbs.board_already_exists', :name => self.name) if BbsBoard.found?(self.name.upcase)
        return nil
      end
      
      def handle
        BbsBoard.create(name: self.name)
        client.emit_success t('bbs.board_created')
      end
    end
  end
end
