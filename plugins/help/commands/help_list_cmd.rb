module AresMUSH
  module Help
    class HelpListCmd
      include CommandHandler
      
      def allow_without_login
        true
      end            
      
      def handle        
        
        toc_list = Help.toc.keys.sort
        paginator = Paginator.paginate(toc_list, cmd.page, 4)
        
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
        else
          template = HelpListTemplate.new(paginator)
          client.emit template.render        
        end
      end
    end
  end
end
