module AresMUSH

  module Idle
    class IdleExecuteCmd
      include CommandHandler

      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def check_idle_in_progress
        return t('idle.idle_not_started') if !client.program[:idle_queue]
        return nil
      end
      
      def handle
        report = []
        client.program[:idle_queue].sort_by { |id, action| action }.each do |id, action|
          idle_char = Character[id]
          char_name = idle_char.name.ljust(20)
          case action
          when "Destroy"
            Global.logger.debug "#{idle_char.name} deleted for idling out."
            idle_char.delete
          when "Roster"
            Global.logger.debug "#{idle_char.name} added to roster."
            Roster::Api.add_to_roster(idle_char)
            report << "#{char_name} - #{t('idle.added_to_roster')}"
          when "Npc"
            idle_char.update(is_npc: true)
            report << "#{char_name} - #{t('idle.turned_to_npc')}"
          when "Warn"
            Global.logger.debug "#{idle_char.name} idle warned."
            report << "#{char_name} - #{t('idle.idle_warning')}"
          when "Nothing"
            # Do nothing
          else
            Global.logger.debug "#{idle_char.name} idled out with action #{action}."
            idle_status = idle_char.get_or_create_idle_status
            idle_status.update(status: action)
            report << "#{char_name} - #{action}"
          end
        end
        
        client.program.delete(:idle_queue)
        
        client.emit BorderedDisplay.list report.sort
        
        Bbs::Api.system_post(
          Global.read_config("idle", "idle_board"), 
          t('idle.idle_bbs_subject'), 
          t('idle.idle_bbs_body', :report => report.join("%R")))
      end
    end
  end
end
