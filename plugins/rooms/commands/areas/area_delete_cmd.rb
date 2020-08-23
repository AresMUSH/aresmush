module AresMUSH
  module Rooms
    class AreaDeleteCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        area = Area.find_one_by_name(self.name)
        
        if (!Rooms.can_delete_area?(area))
          client.emit_failure t('rooms.cant_delete_area')
          return
        end
        
        if (area)
          area.delete
          client.emit_success t('rooms.area_deleted', :name => self.name)
        else
          client.emit_failure t('rooms.area_not_found')
        end
      end
    end
  end
end
