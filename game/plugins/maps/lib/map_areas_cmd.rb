module AresMUSH
  module Maps
    class MapAreasCmd
      include CommandHandler
      
      attr_accessor :name, :areas
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.areas = split_and_titlecase_arg(args.arg2, ',')
      end
      
      def required_args
        {
          args: [ self.name, self.areas ],
          help: 'maps'
        }
      end
      
      def handle
        map = GameMap.find_one_by_name(self.name)
        if (map)
          map.update(areas: self.areas)
          client.emit_success t('maps.map_updated', :name => self.name)
        else
          client.emit_failure t('maps.map_not_available', :name => self.name)
        end
      end
    end
  end
end
