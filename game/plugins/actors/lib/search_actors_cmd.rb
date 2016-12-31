module AresMUSH

  module Actors
    class ActorsSearchCmd
      include CommandHandler
      
      attr_accessor :name

      def crack!
        self.name = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'actors'
        }
      end
        
      def handle
        list = ActorRegistry.all.sort_by(:charname, order: "ALPHA")
        list = list.select { |a| is_match?(a) }
        paginator = Paginator.paginate(list, 1, 100)
        
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
        else
          template = ActorsListTemplate.new(paginator) 
          client.emit template.render
        end
      end
      
      def is_match?(actor)
        return true if actor.charname.upcase == self.name.upcase
        return actor.actor.upcase =~ /#{self.name.upcase}/
      end
        
    end
  end
end
