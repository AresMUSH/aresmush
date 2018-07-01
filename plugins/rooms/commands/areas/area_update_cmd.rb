module AresMUSH
  module Rooms
    class AreaUpdateCmd
      include CommandHandler
      
      attr_accessor :name, :description
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = titlecase_arg(args.arg1)
        self.description = args.arg2
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        area = Area.find_one_by_name(self.name)
        if (area)
          area.update(description: self.description)
          client.emit_success t('rooms.area_updated', :name => self.name)
        else
          client.emit_failure t('rooms.area_not_found')
        end
      end
    end
  end
end
