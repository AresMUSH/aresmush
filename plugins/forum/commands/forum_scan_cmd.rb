module AresMUSH
  module Forum
    class ForumScanCmd
      include CommandHandler
      
      def handle
        
        unread = {}
        BbsBoard.all_sorted.each do |b|
          posts = b.unread_posts(enactor)
          next if posts.empty?
          unread[b] = posts.count
        end
        
        if (unread.empty?)
          client.emit_success t('forum.no_new_posts')
          return
        end
        
        #text = unread.map { |board, count|  t('forum.scan_summary', :num => board.order, :name => board.name, :count => count) }
        #.join(", ")
        #client.emit_ooc text
        
        list = unread.map { |board, count| "#{board.category_index}. #{board.name.ljust(25)} #{t('forum.scan_count', :count => count)}" }
        template = BorderedListTemplate.new list, t('forum.scan_title')
         client.emit template.render
      end
    end
  end
end