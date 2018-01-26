module AresMUSH

  module Idle
    class RosterListCmd
      include CommandHandler
      
      def check_roster_enabled
        return t('idle.roster_disabled') if !Idle.roster_enabled?
        return nil
      end
      
      def handle
        roster = Character.all
           .select { |c| c.on_roster? }
           .sort { |a,b| [a.group('Position') || "", a.name] <=> [b.group('Position') || "", b.name] }
        paginator = Paginator.paginate(roster, cmd.page, 8)
        
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
