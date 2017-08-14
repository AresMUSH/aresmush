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
          toc_list[toc] = Help.toc_topics(toc)
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
