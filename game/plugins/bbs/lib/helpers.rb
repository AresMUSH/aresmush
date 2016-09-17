module AresMUSH
  module Bbs
    def self.can_manage_bbs?(actor)
      return actor.has_any_role?(Global.read_config("bbs", "roles", "can_manage_bbs"))
    end

    def self.can_write_board?(char, board)
      board.write_roles.empty? || char.has_any_role?(board.write_roles) || can_manage_bbs?(char)
    end
    
    def self.can_read_board?(char, board)
      board.read_roles.empty? || char.has_any_role?(board.read_roles) || can_manage_bbs?(char)
    end
    
    # Important: Client may actually be nil here for a system-initiated bbpost.
    def self.with_a_board(board_name, client, &block)
      if (board_name.is_integer?)
        board = BbsBoard.all_sorted[board_name.to_i - 1] rescue nil
      else
        board = BbsBoard.all_sorted.find { |b| b.name.upcase == board_name.upcase }
      end

      if (board.nil?)
        if (client.nil?)
          Global.logger.warn "System tried to post to #{board_name}, which does not exist."
        else
          client.emit_failure t('bbs.board_doesnt_exist', :board => board_name) 
        end
        return
      end
      
      if (!client.nil?)
        if (!can_read_board?(client.char, board))
          client.emit_failure t('bbs.cannot_access_board')
          return
        end
      end
      
      yield board
    end
    
    def self.with_a_post(board_name, num, client, &block)
      with_a_board(board_name, client) do |board|
        
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
        
        post = board.bbs_posts[index]
        
        yield board, post
      end
    end
    
    def self.can_edit_post(char, post)
      post.authored_by?(char) || can_manage_bbs?(char)
    end
    
    def self.mark_read_for_player(char, post)
      post.mark_read(char)
      Handles::Interface.alts(char).each do |alt|
        post.mark_read(alt)
      end
    end
    
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
        message: message, author: author)
        
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
  
