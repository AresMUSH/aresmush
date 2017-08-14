module AresMUSH
  module Bbs
    class BbsDeleteBoardCmd
      include CommandHandler
           
      attr_accessor :name

      def help
        "`bbs/deleteboard <board>` - Deletes a board."
      end
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Bbs.can_manage_bbs?(enactor)
        return nil
      end
      
      def handle
        Bbs.with_a_board(self.name, client, enactor) do |board|
          client.program[:delete_bbs] = board
          
          template = BorderedDisplayTemplate.new t('bbs.board_confirm_delete', :board => board.name)
          client.emit template.render
        end
      end
    end
  end
end
