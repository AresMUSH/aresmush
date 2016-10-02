module AresMUSH
  module Utils
    class SweepCmd
      include CommandHandler
      include CommandWithoutArgs
      include CommandRequiresLogin
      
      attr_accessor :message
      
      def handle
        outside = enactor_room.way_out
        footer = !outside ? nil : "%l2%R" + t('sweep.kick_allowed')
        
        client.emit footer
        snoopers = enactor_room.characters.select { |c| !c.is_online? }
        client.emit BorderedDisplay.list snoopers.map { |c| c.name },
          t('sweep.listening_chars'),
          footer
      end
    end
  end
end
