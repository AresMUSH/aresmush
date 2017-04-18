module AresMUSH

  module Idle
    class RosterListCmd
      include CommandHandler
      
      def handle
        roster = Character.all.select { |c| c.on_roster? }.sort { |a,b| a.name <=> b.name }
        paginator = Paginator.paginate(roster, cmd.page, 15)
        
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
