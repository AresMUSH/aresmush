module AresMUSH
  module Forum
    class ForumTopicRequestHandler
      def handle(request)
                
        topic_id = request.args[:topic_id]
        enactor = request.enactor
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: "Topic not found." }
        end
        
        category = topic.bbs_board
        if (!Forum.can_read_category?(enactor, category))
          return { error: "You don't have access to that category." }
        end
        
        if (enactor)
          Forum.mark_read_for_player(enactor, topic)
        end

        replies = topic.bbs_replies.map { |r|
          { id: r.id,
            author: {
            name: r.author_name,
            icon: r.author ? WebHelpers.icon_for_char(r.author) : nil },
            message: WebHelpers.format_markdown_for_html(r.message),
            date: r.created_date_str(enactor)
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
               icon: topic.author ? WebHelpers.icon_for_char(topic.author) : nil },
             message: WebHelpers.format_markdown_for_html(topic.message),
             replies: replies,
             can_reply: Forum.can_write_to_category?(enactor, category)
             
        }
      end
    end
  end
end