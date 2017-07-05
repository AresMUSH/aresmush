module AresMUSH
  module Bbs
    def self.can_manage_bbs?(actor)
      actor.has_permission?("manage_bbs")
    end

    def self.can_write_board?(char, board)
      roles = board.write_roles.to_a
      !roles || roles.empty? || char.has_any_role?(roles) || can_manage_bbs?(char)
    end
    
    def self.can_read_board?(char, board)
      roles = board.read_roles.to_a
      everyone = Role.find_one_by_name("Everyone")
      char_can_read = char ? (char.has_any_role?(roles) || can_manage_bbs?(char)) : false
      !roles || roles.empty? || char_can_read || roles.include?(everyone)
    end
            
    def self.can_edit_post?(char, post)
      post.authored_by?(char) || can_manage_bbs?(char)
    end
    
    def self.has_unread_bbs?(char)
      BbsBoard.all.each do |b|
        if (b.has_unread?(char))
          return true
        end
      end
      return false
    end
    
    def self.system_post(configured_board, subject, message)
      return if !configured_board
      return if configured_board.blank?
  
      Bbs.post(configured_board, subject, message, Game.master.system_character)
    end
    
    def self.mark_read_for_player(char, post)
      post.mark_read(char)
      AresCentral.alts(char).each do |alt|
        post.mark_read(alt)
      end
    end
    def self.system_post_to_bbs_if_configured(configured_board, subject, message)
      return if !configured_board
      return if configured_board.blank?
    
      Bbs.post(configured_board, subject, message, Game.master.system_character)
    end
    
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
                
        Global.client_monitor.logged_in.each do |other_client, other_char|
          if (Bbs.can_read_board?(other_char, board))
            other_client.emit_ooc message
          end
        end
        
        Global.client_monitor.notify_web_clients :new_bbs_post, t('bbs.web_new_post', :subject => subject, :author => author_name)

        new_post
      end
    end
    
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
        
      Global.client_monitor.emit_all_ooc t('bbs.new_reply', :subject => post.subject, 
      :board => board.name, 
      :reference => post.reference_str,
      :author => author.name)
      Global.client_monitor.notify_web_clients :new_bbs_post, t('bbs.web_new_reply', :subject => post.subject, :author => author.name)
    end
  end
end
