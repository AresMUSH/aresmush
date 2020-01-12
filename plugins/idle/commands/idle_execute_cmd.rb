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
          if (action != "Destroy")   
            title = t("idle.idle_#{action.downcase}")
            color = Idle.idle_action_color(action)
            report << "%r#{color}#{title}%xn"
          end
          
          chars.sort_by { |c| c.name }.each do |idle_char|

            if (action != "Destroy")   
              report << idle_char.name 
            end
            
            case action
            when "Destroy"
              Global.logger.debug "#{idle_char.name} deleted for idling out."
              Idle.idle_cleanup(idle_char, action)
              idle_char.delete
            when "Roster"
              Global.logger.debug "#{idle_char.name} added to roster."
              Idle.add_to_roster(idle_char, action)
              # Idle cleanup is done inside add to roster.
            when "Npc"
              idle_char.update(is_npc: true)
              Idle.idle_cleanup(idle_char, action)
            when "Warn"
              Global.logger.debug "#{idle_char.name} idle warned."
              Mail.send_mail([idle_char.name], t('idle.idle_warning_subject'), Global.read_config("idle", "idle_warn_msg"), nil)          
              idle_char.update(idle_warned: true)
            else
              Global.logger.debug "#{idle_char.name} idle status set to: #{action}."
              idle_char.update(idle_state: action)
              Idle.idle_cleanup(idle_char, action)
            end
          end
        end
        
        client.program.delete(:idle_queue)
        
        template = BorderedListTemplate.new report
        client.emit template.render
        
        Forum.system_post(
          Global.read_config("idle", "idle_category"), 
          t('idle.idle_post_subject'), 
          t('idle.idle_post_body', :report => report.join("%R")))
      end      
    end
  end
end
