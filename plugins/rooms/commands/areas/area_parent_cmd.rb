module AresMUSH
  module Rooms
    class AreaParentCmd
      include CommandHandler
      
      attr_accessor :area_name, :parent_name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.area_name = titlecase_arg(args.arg1)
        self.parent_name = titlecase_arg(args.arg2)
      end
      
      def required_args
        [ self.area_name ]
      end
      
      def handle
        area = Area.find_one_by_name(self.area_name)
        if (!area)
          client.emit_failure t('rooms.area_not_found')
          return
        end
        
        if (self.parent_name)
          parent = Area.find_one_by_name(self.parent_name)
          if (!parent)
            client.emit_failure t('rooms.area_not_found')
            return
          end
        else
          parent = nil
        end
        
        if (Rooms.has_parent_area(parent, area))
          client.emit_failure t('rooms.circular_area_parentage')
          return
        end
        
        area.update(parent: parent)
        client.emit_success t('rooms.area_parent_set', :name => self.area_name, :parent => self.parent_name)
        
      end
    end
  end
end
