module AresMUSH
  
  module Bbs
    # Important: Client may actually be nil here for a system-initiated bbpost.
    def self.with_a_board(board_name, client, enactor, &block)
      if (board_name.is_integer?)
        board = BbsBoard.all_sorted[board_name.to_i - 1] rescue nil
      else
        board = BbsBoard.find_one_by_name(board_name)
        if (!board)
          possible_matches = BbsBoard.all.select { |b| b.name_upcase.starts_with?(board_name.upcase) }
          if (possible_matches.count == 1)
            board = possible_matches.first
          end
        end
      end

      if (!board)
        if (!client)
          Global.logger.warn "System tried to post to #{board_name}, which does not exist."
        else
          client.emit_failure t('bbs.board_doesnt_exist', :board => board_name) 
        end
        return
      end
      
      if (client)
        if (!can_read_board?(enactor, board))
          client.emit_failure t('bbs.cannot_access_board')
          return
        end
      end
      
      yield board
    end
    
    def self.with_a_post(board_name, num, client, enactor, &block)
      with_a_board(board_name, client, enactor) do |board|
        
        if (!num.is_integer?)
          client.emit_failure t('bbs.invalid_post_number')
          return
        end
         
        index = num.to_i - 1
        if (index < 0) 
          client.emit_failure t('bbs.invalid_post_number')
          return
        end
        
        if (board.bbs_posts.count <= index)
          client.emit_failure t('bbs.invalid_post_number')
          return
        end
        
        post = board.bbs_posts.to_a[index]
        
        yield board, post
      end
    end
  end
end
  
