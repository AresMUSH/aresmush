module AresMUSH
  module Bbs
    def self.system_post_to_bbs_if_configured(configured_board, subject, message)
      return if !configured_board
      return if configured_board.blank?
    
      Bbs.post(configured_board, subject, message, Game.master.system_character)
    end
    
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
        message: message, author_id: author.id)
        
        if (!client.nil?)
          Bbs.mark_read_for_player(client.char, post)
        end
                
        Global.client_monitor.emit_all_ooc t('bbs.new_post', :subject => subject, 
        :board => board.name, 
        :reference => post.reference_str,
        :author => client.nil? ? t('bbs.system_author') : client.name)
      end
    end
  end
end