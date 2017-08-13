module AresMUSH
  module Bbs
    class BbsNewCmd
      include CommandHandler
      
      def help
        "`bbs/new` - Reads the first unread message on any board."
      end
      
      def handle
        first_unread = nil
        board = nil
        BbsBoard.all_sorted.each do |b|
          board = b
          first_unread = b.first_unread(enactor)
          break if first_unread
        end
          
        if (!first_unread)
          client.emit_success t('bbs.no_new_posts')
          return
        end
        
        template = PostTemplate.new(board, first_unread, enactor)
        client.emit template.render
        
        Bbs.mark_read_for_player(enactor, first_unread)
        client.program[:last_bbs_post] = first_unread
      end
    end
  end
end