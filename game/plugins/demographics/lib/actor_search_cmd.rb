module AresMUSH

  module Demographics
    class ActorSearchCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
        
      def handle
        list = Character.all.select { |a| is_match?(a) }
        list = list.sort { |a,b| a.name <=> b.name }
        paginator = Paginator.paginate(list, 1, 100)
        
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
        else
          template = ActorsListTemplate.new(paginator) 
          client.emit template.render
        end
      end
      
      def is_match?(char)
        actor = char.demographic(:actor)
        return if !actor
        return true if actor.upcase == self.name.upcase
        return actor.upcase =~ /#{self.name.upcase}/
      end
        
    end
  end
end