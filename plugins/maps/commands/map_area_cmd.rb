module AresMUSH
  module Maps
    class MapAreaCmd
      include CommandHandler
      
      attr_accessor :area_name, :map_name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.area_name = titlecase_arg(args.arg1)
        self.map_name = titlecase_arg(args.arg2)
      end
      
      def required_args
        [ self.area_name ]
      end
      
      def handle
        if (self.map_name)
          map = GameMap.find_one_by_name(self.map_name)
          if (!map)
            client.emit_failure t('maps.map_not_available', :name => self.map_name)
            return
          end
        else
          map = nil
        end
        
        area = Area.find_one_by_name(self.area_name)
        if (!area)
          client.emit_failure t('maps.area_not_found')
          return
        end
        
        area.update(map: map)
        client.emit_success t('maps.area_map_set', :area => self.area_name, :map => self.map_name)
      end
    end
  end
end
