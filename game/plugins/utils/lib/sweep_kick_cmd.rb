module AresMUSH
  module Utils
    class SweepKickCmd
      include CommandHandler
      include CommandWithoutArgs
      include CommandRequiresLogin
      
      attr_accessor :message
      
      def handle
        outside = client.room.way_out
        
        if (outside.nil?)
          client.emit_failure t('sweep.cant_find_exit')
          return
        end
        
        client.room.characters.each do |c|
          other_client = c.client
          if (other_client.nil?)
            Rooms::Api.move_to(nil, c, outside.dest)
          end
        end
        
        client.emit_success t('sweep.sweep_complete')
      end
    end
  end
end
