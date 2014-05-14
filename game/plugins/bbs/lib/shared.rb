module AresMUSH
  module Bbs
    def self.can_manage_bbs?(actor)
      return actor.has_any_role?(Global.config["bbs"]["roles"]["can_manage_bbs"])
    end

    def self.can_write_board?(char, board)
      board.write_roles.empty? || char.has_any_role?(board.write_roles) || can_manage_bbs?(char)
    end
    
    def self.can_read_board?(char, board)
      board.read_roles.empty? || char.has_any_role?(board.read_roles) || can_manage_bbs?(char)
    end
    
    def self.with_a_board(board_name, client, &block)
      if (board_name =~ /\A[\d]+\z/)
        board = BbsBoard.all_sorted[Integer(board_name) - 1] rescue nil
      else
        board = BbsBoard.find_by_name(board_name)
      end
      
      if (board.nil?)
        client.emit_failure t('bbs.board_doesnt_exist', :board => board_name) 
        return
      end
      
      if (!can_read_board?(client.char, board))
        client.emit_failure t('bbs.cannot_access_board')
        return
      end
      
      yield board
    end
    
    def self.with_a_post(board_name, num, client, &block)
      with_a_board(board_name, client) do |board|
        if (num !~ /^[\d]+$/)
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
        
        post = board.bbs_posts[index]
        
        yield board, post
      end
    end
    
    def self.can_edit_post(char, post)
      char.authored_bbposts.include?(post) || can_manage_bbs?(char)
    end
  end
end
  
