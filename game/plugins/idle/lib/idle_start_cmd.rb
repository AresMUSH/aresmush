module AresMUSH

  module Idle
    class IdleStartCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("idle") && cmd.switch_is?("start")
      end

      def check_can_manage
        return nil if Idle.can_idle_sweep?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        client.program[:idle_queue] = {}
        
        Character.each do |c|
          next if !c.last_on
          next if Idle.is_exempt?(c)
          idle_secs = Time.now - c.last_on
          idle_timeout = Global.read_config("idle", "days_before_idle")
          if (idle_secs / 86400 > idle_timeout)
            if (c.is_approved?)
              client.program[:idle_queue][c] = "Npc"
            else
              client.program[:idle_queue][c] = "Destroy"
            end
          end
        end
        
        client.emit Idle.print_idle_queue(client)
      end
    end
  end
end
