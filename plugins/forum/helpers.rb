module AresMUSH
  
  module Forum
    
    def self.can_manage_forum?(actor)
      actor.has_permission?("manage_forum")
    end

    # NOTE: May return nil
    def self.get_forum_prefs(char, category)
      prefs = char.bbs_prefs
      return prefs ? prefs.find(bbs_board_id: category.id).first : nil
    end
    
    def self.can_write_to_category?(char, category)
      return false if !category
      roles = category.write_roles.to_a
      everyone = Role.find_one_by_name("Everyone")
      return true if !roles || roles.empty? || roles.include?(everyone)
      
      return false if !char
      return false if !char.is_approved?
      return char.has_any_role?(roles) || can_manage_forum?(char)
    end
    
    def self.can_read_category?(char, category)
      return false if !category
      roles = category.read_roles.to_a
      everyone = Role.find_one_by_name("Everyone")
      return true if !roles || roles.empty? || roles.include?(everyone)

      return false if !char
      return char.has_any_role?(roles) || can_manage_forum?(char)
    end
            
    def self.can_edit_post?(char, post)
      return false if !post
      post.authored_by?(char) || can_manage_forum?(char)
    end
    
    def self.mark_read_for_player(char, post)
      post.mark_read(char)
      AresCentral.alts(char).each do |alt|
        post.mark_read(alt)
      end
    end    
      

    
    # Client may be nil for automated bbposts.  Otherwise it will be used
    # to emit error messages.
    def self.post(category_name, subject, message, author, client = nil)
      Forum.with_a_category(category_name, client, author) do |category|
      
        if (client)
          if (!Forum.can_write_to_category?(author, category))
            client.emit_failure(t('forum.cannot_post'))
            return
          end
        end
      
        new_post = BbsPost.create(bbs_board: category, 
        subject: subject, 
        message: message, author: author)
        
        if (client)
          Forum.mark_read_for_player(author, new_post)
        end
               
        author_name = author ? author.name : t('forum.system_author')
        message = t('forum.new_post', :subject => subject, 
          :category => category.name, 
          :reference => new_post.reference_str,
          :author => author_name)
                
        Global.notifier.notify_ooc(:new_forum_post, message) do |char|
          !Forum.is_forum_muted?(char) &&
          Forum.can_read_category?(char, category) &&
          !Forum.is_category_hidden?(char, category)
        end

        Forum.handle_forum_achievement(author, :post)
        
        new_post
      end
    end
    
    # Client may be nil for automated bbposts.  Otherwise it will be used
    # to emit error messages.
    def self.reply(category, post, author, reply, client = nil)
      if (!Forum.can_write_to_category?(author, category))
        if (client)
          client.emit_failure(t('forum.cannot_post'))
        end
        return
      end

      reply = BbsReply.create(author: author, bbs_post: post, message: reply)
        
      post.mark_unread
      Forum.mark_read_for_player(author, post)

      message = t('forum.new_reply', :subject => post.subject, 
        :category => category.name, 
        :reference => post.reference_str,
        :author => author.name)
      
      Forum.handle_forum_achievement(author, :reply)
      
      Global.notifier.notify_ooc(:new_forum_post, message) do |char|
        !Forum.is_forum_muted?(char) &&
        Forum.can_read_category?(char, category) &&
        !Forum.is_category_hidden?(char, category)
      end
    end
    
    # Important: Client may actually be nil here for a system-initiated bbpost.
    def self.with_a_category(category_name, client, enactor, &block)
      if (category_name.is_integer?)
        category = BbsBoard.all_sorted[category_name.to_i - 1] rescue nil
      else
        category = BbsBoard.find_one_by_name(category_name)
        if (!category)
          possible_matches = BbsBoard.all.select { |b| b.name_upcase.starts_with?(category_name.upcase) }
          if (possible_matches.count == 1)
            category = possible_matches.first
          end
        end
      end

      if (!category)
        if (!client)
          Global.logger.warn "System tried to post to #{category_name}, which does not exist."
        else
          client.emit_failure t('forum.category_doesnt_exist', :category => category_name) 
        end
        return
      end
      
      if (client)
        if (!can_read_category?(enactor, category))
          client.emit_failure t('forum.cannot_access_category')
          return
        end
      end
      
      yield category
    end
    
    def self.with_a_post(category_name, num, client, enactor, &block)
      with_a_category(category_name, client, enactor) do |category|
        
        if (!num.is_integer?)
          client.emit_failure t('forum.invalid_post_number')
          return
        end
         
        index = num.to_i - 1
        if (index < 0) 
          client.emit_failure t('forum.invalid_post_number')
          return
        end
        
        if (category.bbs_posts.count <= index)
          client.emit_failure t('forum.invalid_post_number')
          return
        end
        
        post = category.sorted_posts[index]
        
        yield category, post
      end
    end
    
    def self.handle_forum_achievement(char, type)
      if (type == :reply)
        message = "Replied to a forum post."
        type = "forum_reply"
      else
        message = "Created a forum post."
        type = "forum_post"
      end
      
      Achievements.award_achievement(char, type, 'community', message)
    end
    
    def self.is_category_hidden?(char, category)
      return false if !char
      prefs = Forum.get_forum_prefs(char, category)
      return prefs ? prefs.hidden : false
    end
    
    def self.visible_categories(char)
      BbsBoard.all_sorted.select { |b| !Forum.is_category_hidden?(char, b) }
    end
    
    def self.hidden_categories(char)
      BbsBoard.all_sorted.select { |b| Forum.is_category_hidden?(char, b) }
    end
    
    def self.is_forum_muted?(char)
      return false if !char
      return char.is_forum_muted?
    end
  end
end
  
