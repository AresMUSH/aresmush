module AresMUSH
  module Forum
    class ForumScanCmd
      include CommandHandler
      
      def handle
        
        unread = []
        BbsBoard.all_sorted.each do |b|
          unread.concat b.unread_posts(enactor)
        end
        
        if (unread.empty?)
          client.emit_success t('forum.no_new_posts')
          return
        end
        
        list = unread.map { |u| "#{u.reference_str} #{u.bbs_board.name} - #{u.subject}"}
        
        
        template = BorderedListTemplate.new list, t('forum.scan_title')
        client.emit template.render
      end
    end
  end
end