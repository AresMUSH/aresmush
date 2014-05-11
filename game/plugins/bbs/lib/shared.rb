module AresMUSH
  module Bbs
    def self.can_manage_bbs?(actor)
      return actor.has_any_role?(Global.config["bbs"]["roles"]["can_manage_bbs"])
    end

    def self.can_write_board?(char, board)
      return true if board.write_roles.empty?
      return char.has_any_role?(board.write_roles)
    end
    
    def self.can_read_board?(char, board)
      return true if board.read_roles.empty?
      return char.has_any_role?(board.read_roles)
    end
    
    def self.with_a_board(name, client, &block)
      if (name =~ /\A[\d]+\z/)
        board = BbsBoard.all_sorted[Integer(name) - 1] rescue nil
      else
        board = BbsBoard.find_by_name(name)
      end
      
      if (board.nil?)
        client.emit_failure t('bbs.board_doesnt_exist', :name => name) 
        return
      end
      
      yield board
    end
    
    def self.with_a_post(name, num, client, &block)
      with_a_board(name, client) do |board|
        if (num !~ /^[\d]+$/)
          client.emit_failure t('bbs.invalid_post_number')
          return
        end
         
        index = num.to_i - 1
        if (index < 0) 
          client.emit_failure t('bbs.invalid_post_number')
          return
        end
        
        if (board.bbs_posts.count < index)
          client.emit_failure t('bbs.invalid_post_number')
          return
        end
        
        post = board.bbs_posts[index]
        
        yield board, post
      end
    end
  end
end
  
