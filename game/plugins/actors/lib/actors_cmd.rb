module AresMUSH

  module Actors
    class ActorsListCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :page

      def want_command?(client, cmd)
        cmd.root_is?("actor") && !cmd.switch && !cmd.args
      end

      def crack!
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle
        list = ActorRegistry.all.sort { |a,b| a.charname <=> b.charname }        
        paginator = Paginator.paginate(list, self.page, 15)
        
        template = ActorsListTemplate.new(paginator, client) 
        template.render
      end
    end
  end
end
