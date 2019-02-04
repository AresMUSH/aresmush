module AresMUSH
  module Rooms
    class RoomsCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end

      def handle
        if (!self.name)
          objects = Room.all.to_a
        else
          objects = Room.all.select { |r| r.name_upcase =~ /#{self.name.upcase}/ }
        end
        
        if (!Rooms.can_build?(enactor))
          objects = objects.sort_by { |r| r.name_upcase }
        end
        objects = objects.map { |r| format_name(r) }
        template = BorderedListTemplate.new objects, t('rooms.room_directory')
        client.emit template.render
      end
      
      def format_name(r)
        db = Rooms.can_build?(enactor) ? "#{r.dbref} - #{r.room_type.ljust(3)} - " : ""
        area = r.area ? "(#{r.area_name})" : ""
        "#{db}#{r.name}#{area}"
      end
    end
  end
end
