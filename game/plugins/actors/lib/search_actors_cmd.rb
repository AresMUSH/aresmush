module AresMUSH

  module Actors
    class ActorsSearchCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'actors'
        super
      end

      def crack!
        self.name = trim_input(cmd.args)
      end
      
      def handle
        list = ActorRegistry.all.select { |a| is_match?(a) }
        list = list.sort { |a,b| a.charname <=> b.charname }
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
