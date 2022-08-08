module AresMUSH
  module Rooms
    class ExitsCmd
      include CommandHandler
      
      attr_accessor :details

      def parse_args
        self.details = cmd.switch_is?("detail") || cmd.switch_is?("details")
      end
        
      def check_can_build
        return t('dispatcher.not_allowed') if self.details && !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        if (self.details)
          list = enactor_room.exits.map { |e| "#{e.dbref.ljust(6)} #{e.name.ljust(10)} #{e.destination_name}" }
        elsif client.screen_reader
          
          list = enactor_room.exits
            .to_a
            .sort_by { |e| e.name }
            .map { |e| "#{e.name} - #{e.destination_name}"}
          
        else
          list = enactor_room.exits
            .to_a
            .sort_by { |e| e.name }
            .map { |e| "#{Describe.format_exit_name(e)} #{e.destination_name}"}
          
         end
        template = BorderedListTemplate.new list
        client.emit template.render
      end
    end
  end
end
