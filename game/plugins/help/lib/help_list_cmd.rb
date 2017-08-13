module AresMUSH
  module Help
    class HelpListCmd
      include CommandHandler
      
      def allow_without_login
        true
      end            
      
      def handle        
        toc_list = {}
        Help.toc.each do |toc|
          index_topics = Help.toc_topics(toc).select { |k, v| v['topic'] == 'index' }
          toc_list[toc] = index_topics
        end
        
        paginator = Paginator.paginate(toc_list.keys, cmd.page, 8)
        
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
        else
          template = HelpListTemplate.new(paginator, toc_list)
          client.emit template.render        
        end
      end
    end
  end
end
