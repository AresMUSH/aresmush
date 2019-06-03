module AresMUSH
  module Rooms
    class AreaRenameCmd
      include CommandHandler
      
      attr_accessor :name, :new_name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = titlecase_arg(args.arg1)
        self.new_name = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.new_name ]
      end
      
      def handle
        area = Area.find_one_by_name(self.name)
        new_area = Area.find_one_by_name(self.new_name)
        
        if (new_area)
          client.emit_failure t('rooms.area_already_exists', :name => self.new_name)
          return
        end

        area.update(name: self.new_name)
        client.emit_success t('rooms.area_updated', :name => self.name)
      end
    end
  end
end
