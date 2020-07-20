module AresMUSH
  
  module Forum
    
    def self.can_manage_forum?(actor)
      actor && actor.has_permission?("manage_forum")
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
      return false if !char
      post.authored_by?(char) || can_manage_forum?(char)
    end
    
    def self.mark_read_for_player(char, post)
      Forum.mark_read(post, char)
      AresCentral.alts(char).each do |alt|
        Forum.mark_read(post, alt)
      end
      Login.mark_notices_read(char, :forum, post.id)
    end    
      
    def self.notify(post, category, type, message, data)
      Global.notifier.notify_ooc(type, message) do |char|
        !Forum.is_forum_muted?(char) &&
        Forum.can_read_category?(char, category) &&
        !Forum.is_category_hidden?(char, category)
      end
      
      Global.client_monitor.notify_web_clients('new_forum_activity', "#{data.to_json}", true) do |char|
        Forum.can_read_category?(char, category) &&
        !Forum.is_category_hidden?(char, category)
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
               
        author_name = author.name
        message = t('forum.new_post', :subject => subject, 
          :category => category.name, 
          :reference => new_post.reference_str,
          :author => author_name)
        
        Forum.add_recent_post(new_post)
        data = {
          category: category.id,
          post: new_post.id,
          author: {name: author_name, icon: Website.icon_for_char(author), id: author.id},
          subject: subject,
          message: Website.format_markdown_for_html(message),
          raw_message: message,
          type: 'new_forum_post'
        }
        Forum.notify(new_post, category, :new_forum_post, message, data)
        Achievements.award_achievement(author, "forum_post")
        
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

      new_reply = BbsReply.create(author: author, bbs_post: post, message: reply)
        
      Forum.mark_unread(post)
      Forum.mark_read_for_player(author, post)

      message = t('forum.new_reply', :subject => post.subject, 
        :category => category.name, 
        :reference => post.reference_str,
        :author => author.name)
      
        data = {
          category: category.id,
          post: post.id,
          reply: new_reply.id,
          author: { name: author.name, icon: Website.icon_for_char(author), id: author.id },
          subject: post.subject,
          message: Website.format_markdown_for_html(reply),
          raw_message: reply,
          type: 'forum_reply'
        }
        
      Forum.add_recent_post(post)
      Achievements.award_achievement(author, "forum_reply")
      Forum.notify(post, category, :new_forum_reply, message, data)
            
      if (post.author && author != post.author)
        Login.notify(post.author, :forum, t('forum.new_forum_reply', :subject => post.subject), post.id, "#{category.id}|#{post.id}")
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
        
        if (!"#{num}".is_integer?)
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
    
    def self.is_unread?(post, char)
      tracker = char.get_or_create_read_tracker
      tracker.is_forum_post_unread?(post)
    end
    
    def self.mark_read(post, char)
      tracker = char.get_or_create_read_tracker
      tracker.mark_forum_post_read(post)
    end
    
    def self.mark_unread(post)
      chars = Character.all.select { |c| !Forum.is_unread?(post, c) }
      chars.each do |char|
        tracker = char.get_or_create_read_tracker
        tracker.mark_forum_post_unread(post)
      end
    end
    
    def self.edit_post(post, enactor, subject, message)
      post.update(message: message)
      post.update(subject: subject)
      Forum.mark_unread(post)
      category = post.bbs_board
      notification = t('forum.new_edit', :subject => post.subject, 
        :category => category.name, 
        :reference => post.reference_str,
        :author => enactor.name)
        
      data = {
        category: category.id,
        post: post.id,
        author: {name: enactor.name, icon: Website.icon_for_char(enactor), id: enactor.id},
        subject: post.subject,
        message: Website.format_markdown_for_html(message),
        raw_message: message,
        type: 'forum_edited'
      }
      
      Forum.add_recent_post(post)
      Forum.notify(post, category, :forum_edited, notification, data)
      Forum.mark_read_for_player(enactor, post)
    end
    
    def self.edit_reply(reply, enactor, message)
      reply.update(message: message)
      post = reply.bbs_post
      Forum.mark_unread(post)
      category = post.bbs_board
      notification = t('forum.new_reply_edit', :subject => post.subject, 
        :category => category.name, 
        :reference => post.reference_str,
        :author => enactor.name)
      
      data = {
        category: category.id,
        post: post.id,
        reply: reply.id,
        subject: post.subject,
        author: {name: enactor.name, icon: Website.icon_for_char(enactor), id: enactor.id},
        message: Website.format_markdown_for_html(message),
        raw_message: message,
        type: 'reply_edited'
      }
      
      Forum.add_recent_post(post)
      Forum.notify(post, category, :reply_edited, notification, data)
      Forum.mark_read_for_player(enactor, post)
    end
    
    def self.catchup_category(enactor, category)
      category.unread_posts(enactor).each do |p|
        Forum.mark_read_for_player(enactor, p)
      end
    end
    
    def self.add_recent_post(post)
      recent = Game.master.recent_forum_posts
      recent.unshift("#{post.id}")
      recent = recent.uniq
      if (recent.count > 100)
        recent.pop
      end
      Game.master.update(recent_forum_posts: recent)
    end
    
    def self.get_authorable_chars(char, category)
      return [] if !char
      authors = AresCentral.alts(char)
      authors << char
      authors.uniq
        .select { |p| Forum.can_write_to_category?(p, category)}
        .sort_by { |p| [ p == char ? 0 : 1, p.name ]}
        .map { |p| { id: p.id, name: p.name, icon: Website.icon_for_char(p) }}   
     end
  end
end
  
