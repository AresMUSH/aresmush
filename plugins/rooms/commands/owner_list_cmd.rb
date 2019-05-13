module AresMUSH
  module Rooms
    class OwnerListCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = cmd.args || "here"
      end

      def required_args
        [ self.name ]
      end
      
      def handle
        char = Character.named(self.name)
        if (char)
          rooms = Room.all.select { |r| r.room_owners.include?(char) }
        else
          rooms = Room.find_by_name_and_area self.name, enactor_room
        end

        list = rooms.select { |r| r.room_owners.any? }
             .map { |r| "#{r.name}: #{r.room_owners.map { |o| o.name }.join(', ')}" }
        
        if (!list.any?)
          client.emit_failure t('rooms.no_room_owners_found')
          return
        end
            
        template = BorderedListTemplate.new list, t('rooms.owners_title')
        client.emit template.render
        
      end
    end
  end
end