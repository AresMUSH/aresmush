module AresMUSH
  module Utils
    class SweepCmd
      include CommandHandler
      
      attr_accessor :message
      
      def handle
        outside = enactor_room.way_out
        footer = !outside ? nil : "%ld%R" + t('sweep.kick_allowed')
        
        client.emit footer
        snoopers = enactor_room.characters.select { |c| !Login.is_online?(c) }.map { |c| c.name }
        template = BorderedListTemplate.new snoopers, t('sweep.listening_chars'), footer
        client.emit template.render
      end
    end
  end
end
