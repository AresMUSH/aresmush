module AresMUSH
  module Bbs
    def self.post(board_name, subject, message, author, client = nil)
      Bbs.with_a_board(board_name, client) do |board|
      
        if (!client.nil?)
          if (!Bbs.can_write_board?(client.char, board))
            client.emit_failure(t('bbs.cannot_post'))
            return
          end
        end
      
        post = BbsPost.create(bbs_board: board, 
        subject: subject, 
        message: message, author: author)
        
        if (!client.nil?)
          post.mark_read(client.char)
        end
                
        Global.client_monitor.emit_all_ooc t('bbs.new_post', :subject => subject, 
        :board => board.name, 
        :author => client.nil? ? t('bbs.system_author') : client.name)
      end
    end
  end
end