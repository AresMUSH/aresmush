module AresMUSH
  module Bbs
    class BbsNewCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def handle
        first_unread = nil
        board = nil
        BbsBoard.all_sorted.each do |b|
          board = b
          first_unread = b.first_unread(client.char)
          break if !first_unread.nil?
        end
          
        if (first_unread.nil?)
          client.emit_success t('bbs.no_new_posts')
          return
        end
        
        template = PostTemplate.new(board, first_unread, client)
        template.render
        
        Bbs.mark_read_for_player(client.char, first_unread)
        client.program[:last_bbs_post] = first_unread
      end
    end
  end
end