module AresMUSH

  module Actors
    class ActorsListCmd
      include CommandHandler
      
      def handle
        list = ActorRegistry.all.sort_by(:charname, order: "ALPHA")
        paginator = Paginator.paginate(list, cmd.page, 15)
        
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
        else
          template = ActorsListTemplate.new(paginator) 
          client.emit template.render
        end
      end
    end
  end
end
