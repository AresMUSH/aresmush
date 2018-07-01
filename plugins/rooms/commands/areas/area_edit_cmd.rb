module AresMUSH
  module Rooms
    class AreaEditCmd
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
        if (area)
          Utils.grab client, enactor, "area/update #{self.name}=#{area.description}"
        else
          client.emit_failure t('area.area_not_found')
        end
      end
    end
  end
end
