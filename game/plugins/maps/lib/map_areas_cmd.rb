module AresMUSH
  module Maps
    class MapAreasCmd
      include CommandHandler
      
      attr_accessor :name, :areas
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.areas = cmd.args.arg2 ? cmd.args.arg2.split(',').map { |m| titleize_input(m) } : nil
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
