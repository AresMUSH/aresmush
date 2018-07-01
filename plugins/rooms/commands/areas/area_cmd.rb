module AresMUSH
  module Rooms
    class AreaCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def handle
        if (self.name)
          area = Area.find_one_by_name(self.name)
        else
          area = enactor_room.area
        end
      
        if (!area)
          client.emit_failure t('rooms.area_not_found')
        else
          template = AreaTemplate.new area
          client.emit template.render
        end
      end
    end
  end
end
