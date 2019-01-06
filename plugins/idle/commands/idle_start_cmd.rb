module AresMUSH

  module Idle
    class IdleStartCmd
      include CommandHandler
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        client.program[:idle_queue] = {}
        
        Idle.active_chars.each do |c|
          last_on = c.last_on || Time.at(0)
          next if Idle.is_exempt?(c)
          next if c.is_npc?
          next if c.on_roster?
          idle_secs = Time.now - last_on
          idle_timeout = Global.read_config("idle", "days_before_idle")
          if (idle_secs / 86400 > idle_timeout)
            if (c.is_approved?)
              client.program[:idle_queue][c.id] = "Warn"
            else
              client.program[:idle_queue][c.id] = "Destroy"
            end
          end
        end

        template = IdleQueueTemplate.new(client.program[:idle_queue], enactor)
        client.emit template.render
        
      end
    end
  end
end
