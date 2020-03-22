module AresMUSH
  module Forum
    class ForumTopicRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: t('webportal.not_found') }
        end
        
        category = topic.bbs_board
        if (!Forum.can_read_category?(enactor, category))
          return { error: t('forum.cannot_access_category' )}
        end
        
        if (enactor)
          Forum.mark_read_for_player(enactor, topic)
        end
        
        replies = topic.bbs_replies.map { |r|
          { id: r.id,
            author: {
            name: r.author_name,
            icon: r.author ? Website.icon_for_char(r.author) : nil },
            message: Website.format_markdown_for_html(r.message),
            raw_message: r.message,
            date: r.created_date_str(enactor),
            can_edit: Forum.can_edit_post?(enactor, r)
          }
        }
        
        {
             id: topic.id,
             title: topic.subject,
             category: {
               id: category.id,
               name: category.name },
             date: topic.created_date_str(enactor),
             author: {
               name: topic.author_name,
               icon: topic.author ? Website.icon_for_char(topic.author) : nil },
             message: Website.format_markdown_for_html(topic.message),
             raw_message: topic.message,
             replies: replies,
             can_reply: Forum.can_write_to_category?(enactor, category),
             can_edit: Forum.can_edit_post?(enactor, topic),
             authors: Forum.get_authorable_chars(enactor, category)
        }
      end
    end
  end
end