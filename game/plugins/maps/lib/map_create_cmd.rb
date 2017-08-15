module AresMUSH
  module Maps
    class MapCreateCmd
      include CommandHandler
      
      attr_accessor :name, :map_text
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.map_text = args.arg2
      end
      
      def required_args
        [ self.name, self.map_text ]
      end
      
      def handle
        map = GameMap.find_one_by_name(self.name)
        if (map)
          map.update(areas: [ self.name ])
          map.update(map_text: self.map_text)
          client.emit_success t('maps.map_updated', :name => self.name)
        else
          GameMap.create(name: self.name, areas: [ self.name ], map_text: self.map_text)
          client.emit_success t('maps.map_created', :name => self.name)
        end
      end
    end
  end
end
