module AresMUSH
  
  module Bbs
    
    def self.can_manage_bbs?(actor)
      actor.has_permission?("manage_bbs")
    end

    def self.can_write_board?(char, board)
      return false if !board
      roles = board.write_roles.to_a
      everyone = Role.find_one_by_name("Everyone")
      return true if !roles || roles.empty? || roles.include?(everyone)
      
      return false if !char
      return false if !char.is_approved?
      return char.has_any_role?(roles) || can_manage_bbs?(char)
    end
    
    def self.can_read_board?(char, board)
      return false if !board
      roles = board.read_roles.to_a
      everyone = Role.find_one_by_name("Everyone")
      return true if !roles || roles.empty? || roles.include?(everyone)

      return false if !char
      return char.has_any_role?(roles) || can_manage_bbs?(char)
    end
            
    def self.can_edit_post?(char, post)
      return false if !post
      post.authored_by?(char) || can_manage_bbs?(char)
    end
    
    def self.mark_read_for_player(char, post)
      post.mark_read(char)
      AresCentral.alts(char).each do |alt|
        post.mark_read(alt)
      end
    end    
      

    
    # Client may be nil for automated bbposts.  Otherwise it will be used
    # to emit error messages.
    def self.post(board_name, subject, message, author, client = nil)
      Bbs.with_a_board(board_name, client, author) do |board|
      
        if (client)
          if (!Bbs.can_write_board?(author, board))
            client.emit_failure(t('bbs.cannot_post'))
            return
          end
        end
      
        new_post = BbsPost.create(bbs_board: board, 
        subject: subject, 
        message: message, author: author)
        
        if (client)
          Bbs.mark_read_for_player(author, new_post)
        end
               
        author_name = client ? author.name : t('bbs.system_author')
        message = t('bbs.new_post', :subject => subject, 
          :board => board.name, 
          :reference => new_post.reference_str,
          :author => author_name)
                
        Global.notifier.notify_ooc(:new_bbs_post, message) do |char|
          Bbs.can_read_board?(char, board)
        end

        new_post
      end
    end
    
    # Client may be nil for automated bbposts.  Otherwise it will be used
    # to emit error messages.
    def self.reply(board, post, author, reply, client = nil)
      if (!Bbs.can_write_board?(author, board))
        if (client)
          client.emit_failure(t('bbs.cannot_post'))
        end
        return
      end

      reply = BbsReply.create(author: author, bbs_post: post, message: reply)
        
      post.mark_unread
      Bbs.mark_read_for_player(author, post)

      message = t('bbs.new_reply', :subject => post.subject, 
        :board => board.name, 
        :reference => post.reference_str,
        :author => author.name)
      
      Global.notifier.notify_ooc(:new_bbs_post, message) do |char|
        Bbs.can_read_board?(char, board)
      end
    end
    
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
  
