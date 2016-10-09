module AresMUSH

  module Idle
    class IdleStartCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        client.program[:idle_queue] = {}
        
        Character.all.each do |c|
          last_on = c.last_on
          next if !last_on
          next if Idle.is_exempt?(c)
          idle_secs = Time.now - last_on
          idle_timeout = Global.read_config("idle", "days_before_idle")
          if (idle_secs / 86400 > idle_timeout)
            if (c.is_approved?)
              client.program[:idle_queue][c.id] = "Npc"
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
