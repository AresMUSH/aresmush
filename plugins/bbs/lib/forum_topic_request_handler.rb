module AresMUSH
  module Bbs
    class ForumTopicRequestHandler
      def handle(request)
                
        char_id = request.args[:char_id]
        topic_id = request.args[:topic_id]
        
        topic = BbsPost[topic_id.to_i]
        if (!topic)
          return { error: "Topic not found." }
        end
        
        if (char_id)
          char = Character.find_one_by_name(char_id)
          if (!char)
            return { error: "Character not found." }
          end
        else
          char = nil
        end

        category = topic.bbs_board
        if (!Bbs.can_read_board?(char, category))
          return { error: "You don't have access to that board." }
        end
        
        if (char)
          Bbs.mark_read_for_player(char, topic)
        end

        replies = topic.bbs_replies.map { |r|
          { id: r.id,
            author: {
            name: r.author_name,
            icon: r.author ? WebHelpers.icon_for_char(r.author) : nil },
            message: WebHelpers.format_markdown_for_html(r.message),
            date: r.created_date_str(char)
          }
        }
        
        {
             id: topic.id,
             title: topic.subject,
             category: {
               id: category.id,
               name: category.name },
             date: topic.created_date_str(char),
             author: {
               name: topic.author_name,
               icon: topic.author ? WebHelpers.icon_for_char(topic.author) : nil },
             message: WebHelpers.format_markdown_for_html(topic.message),
             replies: replies,
             can_reply: Bbs.can_write_board?(char, category)
             
        }
      end
    end
  end
end