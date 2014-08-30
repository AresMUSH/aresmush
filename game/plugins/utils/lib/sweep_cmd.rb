module AresMUSH
  module Utils
    class SweepCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginWithoutArgs
      include PluginRequiresLogin
      
      attr_accessor :message
      
      def want_command?(client, cmd)
        cmd.root_is?("sweep")
      end
      
      def handle
        outside = client.room.out_exit
        
        if (outside.nil?)
          client.emit_failure t('sweep.cant_find_exit')
          return
        end
        
        client.room.characters.each do |c|
          other_client = Global.client_monitor.find_client(c)
          if (other_client.nil?)
            Rooms.move_to(nil, c, outside.dest)
          end
        end
        
        client.emit_success t('sweep.sweep_complete')
      end
    end
  end
end
