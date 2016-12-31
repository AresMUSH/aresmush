module AresMUSH
  module Maps
    class MapCreateCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :map_text
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.map_text = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.name, self.map_text ],
          help: 'maps'
        }
      end
      
      def handle
        map = GameMap.find_one_by_name(self.name)
        if (map)
          map.update(areas: [ self.name ])
          client.emit_success t('maps.map_updated', :name => self.name)
        else
          GameMap.create(name: self.name, areas: [ self.name ], map_text: self.map_text)
          client.emit_success t('maps.map_created', :name => self.name)
        end
      end
    end
  end
end
