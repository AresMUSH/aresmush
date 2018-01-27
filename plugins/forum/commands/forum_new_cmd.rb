module AresMUSH
  module Forum
    class ForumNewCmd
      include CommandHandler
      
      def handle
        first_unread = nil
        category = nil
        BbsBoard.all_sorted.each do |b|
          category = b
          first_unread = b.first_unread(enactor)
          break if first_unread
        end
          
        if (!first_unread)
          client.emit_success t('forum.no_new_posts')
          return
        end
        
        template = PostTemplate.new(category, first_unread, enactor)
        client.emit template.render
        
        Forum.mark_read_for_player(enactor, first_unread)
        client.program[:last_forum_post] = first_unread
      end
    end
  end
end