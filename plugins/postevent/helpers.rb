module AresMUSH
  module PostEvent

    def self.create_forum_post(event)
      category_name = Global.read_config("postevent", "event_forum")
      msg = PostEvent.format_msg(event)
      author = Character.named(event.organizer_name)
      Forum.post(category_name, event.title, msg, author)
    end

    def self.format_msg(event)
      "#{event.title}\n#{t('events.starts_at_title')} #{event.start_datetime_standard}\n#{t('events.who_title')} #{event.organizer_name}\nContent Warning: #{event.content_warning}\n#{t('events.tags_title')} #{event.tags.join(" ")}\n\n#{event.description}\n\n#{Game.web_portal_url}\/event\/#{event.id}"
    end

    def self.reply_to_forum_post(event)
      category_name = Global.read_config("postevent", "event_forum")
      post = PostEvent.find_event_post(event)
      reply = "%xcUPDATED EVENT DETAILS%xn\n\n#{PostEvent.format_msg(event)}"
      author = Character.named(event.organizer_name)
      category = BbsBoard.find_one_by_name(category_name)
      if post == "error"
        client = Global.client_monitor.find_client(author)
        return client.emit_failure "Cannot reply to event forum post with updates; you may want to do it manually. This happens when the event name has changed."
      else
        Forum.reply(category, post, author, reply)
      end
    end

    def self.find_event_post(event)
      category_name = Global.read_config("postevent", "event_forum")
      category = BbsBoard.find_one_by_name(category_name)
      post = category.bbs_posts.select { |post| post.subject == event.title}.last
      if !post
        return "error"
      else
        return post
      end
    end

  end
end
