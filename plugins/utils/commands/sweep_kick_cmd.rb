module AresMUSH
  module Utils
    class SweepKickCmd
      include CommandHandler
      
      attr_accessor :message
      
      def handle
        outside = enactor_room.way_out
        
        if (!outside)
          client.emit_failure t('sweep.cant_find_exit')
          return
        end
        
        enactor_room.characters.each do |c|
          other_client = Login.find_game_client(c)
          if (!other_client)
            Rooms.move_to(nil, c, outside.dest)
          elsif (other_client.idle_secs > 3600)
            other_client.emit_ooc t('sweep.moved_by_room_sweep')
            Rooms.move_to(nil, c, outside.dest)
          end
        end
        
        client.emit_success t('sweep.sweep_complete')
      end
    end
  end
end
