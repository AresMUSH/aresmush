module AresMUSH
  module Idle
    class IdleReviewRequestHandler
      def handle(request)
                
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        if (!Idle.can_idle_sweep?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
       { 
         idle_actions: [ "None", "Warn", "Gone", "Roster", "Npc", "Dead", "Destroy" ],
         chars: Idle.build_idle_queue.map { |id, action| build_char_data(id, action, enactor) }
       }
      end
      
      def build_char_data(id, action, enactor)
        char = Character[id]
        last_on = char.last_on
        
        {
          id: id,
          name: char.name,
          lastwill: char.idle_lastwill,
          last_on: OOCTime.local_long_timestr(enactor, last_on),
          last_on_formatted: last_on ? TimeFormatter.format(Time.now - last_on) : "---",
          notes: char.idle_notes,
          warned: char.idle_warned,
          idle_action: action,
          approved: char.is_approved?,
        }
      end
    end
  end
end