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
        
        client.program[:idle_queue].map { |id, action| action }.uniq.each do |action|
          ids =  client.program[:idle_queue].select { |id, a| a == action }
          chars = ids.map { |id, action| Character[id] }

          # Don't log destroyed chars who never hit the grid
          if (action != "Destroy" && action != "Nothing")   
            title = t("idle.idle_#{action.downcase}")
            color = Idle.idle_action_color(action)
            report << "%r#{color}#{title}%xn"
          end
          
          chars.sort_by { |c| c.name }.each do |idle_char|
            # Don't log destroyed chars who never hit the grid
            if (action != "Destroy" && action != "Nothing")   
              report << idle_char.name               
            end
            
            case action
            when "Destroy"
              Global.logger.debug "#{idle_char.name} deleted for idling out."
              idle_char.delete
            when "Roster"
              Global.logger.debug "#{idle_char.name} added to roster."
              Idle.add_to_roster(idle_char)
            when "Npc"
              idle_char.update(is_npc: true)
              Login::Api.set_random_password(idle_char)
            when "Warn"
              Global.logger.debug "#{idle_char.name} idle warned."
              idle_char.update(idle_warned: true)
            when "Nothing"
              # Do nothing
            when "Reset"
              # Reset their idle status
              idle_char.update(idle_warned: false)
              idle_char.update(is_npc: false)
              if (idle_char.idle_status)
                idle_char.idle_status.delete
              end
              # Remove them from the roster.
              Idle.remove_from_roster(idle_char)
            else
              Global.logger.debug "#{idle_char.name} idle status set to: #{action}."
              idle_status = idle_char.get_or_create_idle_status
              idle_status.update(status: action)
              Login::Api.set_random_password(idle_char)
            end
          end
        end
        
        client.program.delete(:idle_queue)
        
        client.emit BorderedDisplay.list report
        
        Bbs::Api.system_post(
          Global.read_config("idle", "idle_board"), 
          t('idle.idle_bbs_subject'), 
          t('idle.idle_bbs_body', :report => report.join("%R")))
      end      
    end
  end
end
