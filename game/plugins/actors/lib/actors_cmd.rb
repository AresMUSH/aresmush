module AresMUSH

  module Actors
    class ActorsListCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :page

      def crack!
        self.page = cmd.page ? trim_input(cmd.page).to_i : 1
      end
      
      def handle
        list = ActorRegistry.all.sort { |a,b| a.charname <=> b.charname }        
        paginator = Paginator.paginate(list, self.page, 15)
        
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
