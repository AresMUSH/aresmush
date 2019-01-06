module AresMUSH

  module Idle
    class IdlePreviewCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
        
          if (model.on_roster? || model.is_npc? || Idle.is_exempt?(model))
            client.emit_failure t('idle.not_eligible_for_idle')
            return
          end
          
          last_on = model.last_on || Time.at(0)
          idle_secs = Time.now - last_on
          idle_timeout = Global.read_config("idle", "days_before_idle")
          idle_action = "Not Idle"
          if (idle_secs / 86400 > idle_timeout)
            if (model.is_approved?)
              idle_action = "Warn"
            else
              idle_action = "Destroy"
            end
          end
          
          last_on_str = OOCTime.local_short_timestr(enactor, model.last_on)
          
          if (model.idle_warned)
            idle_action += '*'
          end
          
          client.emit_ooc t('idle.idle_preview', :name => model.name, :last_on => last_on_str, 
             :status => model.is_approved? ? "NEW" : "OOC",
             :idle_action => idle_action, :lastwill => model.idle_lastwill )
        end
      end
    end
  end
end
