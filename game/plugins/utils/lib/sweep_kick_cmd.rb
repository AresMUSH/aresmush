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
          other_client = c.client
          if (!other_client)
            Rooms::Api.move_to(nil, c, outside.dest)
          end
        end
        
        client.emit_success t('sweep.sweep_complete')
      end
    end
  end
end
