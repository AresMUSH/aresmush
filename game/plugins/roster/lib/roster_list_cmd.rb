module AresMUSH

  module Roster
    class RosterListCmd
      include CommandHandler
      include CommandRequiresLogin
      include TemplateFormatters
      
      attr_accessor :page

      def crack!
        self.page = !cmd.page ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle
        roster = RosterRegistry.all.sort { |a,b| a.character.name <=> b.character.name }
        paginator = Paginator.paginate(roster, self.page, 15)
        
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
        else
          template = RosterListTemplate.new(paginator) 
          client.emit template.render
        end
      end
    end
  end
end
