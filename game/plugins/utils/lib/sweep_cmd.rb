module AresMUSH
  module Utils
    class SweepCmd
      include CommandHandler
      include CommandWithoutArgs
      include CommandRequiresLogin
      
      attr_accessor :message
      
      def want_command?(client, cmd)
        cmd.root_is?("sweep") && cmd.switch.nil?
      end
      
      def handle
        outside = client.room.way_out
        footer = outside.nil? ? nil : "%l2%R" + t('sweep.kick_allowed')
        
        client.emit footer
        snoopers = client.room.characters.select { |c| !c.is_online? }
        client.emit BorderedDisplay.list snoopers.map { |c| c.name },
          t('sweep.listening_chars'),
          footer
      end
    end
  end
end
