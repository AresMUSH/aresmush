module AresMUSH
  module Bbs
    class BbsArchive
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include TemplateFormatters
      
      attr_accessor :board_name
      
      def crack!
        self.board_name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.board_name ],
          help: 'bbs'
        }
      end
      
      def handle
        client.emit_ooc t('bbs.starting_archive')
        Bbs.with_a_board(self.board_name, client, enactor) do |board|  
          if board.bbs_posts.count > 30
            client.emit_failure t('bbs.too_much_for_archive')
            return
          end
          
          Global.logger.debug "Logging posts from #{board.name}."

          template = ArchiveTemplate.new(board.bbs_posts, enactor)
          client.emit template.render
        end
      end      
    end
  end
end