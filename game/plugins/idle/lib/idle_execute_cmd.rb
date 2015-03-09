module AresMUSH

  module Idle
    class IdleExecuteCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("idle") && cmd.switch_is?("execute")
      end

      def check_can_manage
        return nil if Idle.can_idle_sweep?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def check_idle_in_progress
        queue = client.program[:idle_queue]
        return t('idle.idle_not_started') if !queue
        return nil
      end
      
      def handle
        report = []
        client.program[:idle_queue].each do |idle_char, action|
          case action
          when "Destroy"
            Global.logger.debug "#{idle_char.name} destroyed for idling out."
            idle_char.destroy
          when "Roster"
            Global.logger.debug "#{idle_char.name} added to roster."
            Roster.add_to_roster(idle_char)
            report << "#{idle_char.name} - #{t('idle.added_to_roster')}"
          when "Warn"
            Global.logger.debug "#{idle_char.name} idle warned."
            report << "#{idle_char.name} - #{t('idle.idle_warning')}"
          when "Nothing"
            # Do nothing
          else
            Global.logger.debug "#{idle_char.name} idled out with action #{action}."
            idle_char.idled_out = action
            idle_char.save
            report << "#{idle_char.name} - #{action}"
          end
        end
        
        client.program.delete(:idle_queue)
        
        client.emit BorderedDisplay.list report
        
        Bbs.system_post_to_bbs_if_configured(
          Global.config['idle']['idle_board'], 
          t('idle.idle_bbs_subject'), 
          t('idle.idle_bbs_body', :report => report.join("%R")))
      end
    end
  end
end
