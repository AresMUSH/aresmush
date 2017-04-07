module AresMUSH

  module Demographics
    class ActorsListCmd
      include CommandHandler
      
      def handle
        list = Character.all.select { |c| c.demographic(:actor) && !c.demographic(:actor).blank? }
        
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
