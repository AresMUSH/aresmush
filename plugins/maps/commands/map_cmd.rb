module AresMUSH
  module Maps
    class MapCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def handle
        if (self.name)
          map = GameMap.find_one_by_name(self.name)
          map_name = self.name
        else
          area_name = enactor_room.area ? enactor_room.area.name : nil
          map = Maps.get_map_for_area(area_name)
          map_name = area_name
        end
      
        if (!map)
          client.emit_failure t('maps.no_such_map')
        else
          template = BorderedDisplayTemplate.new map.map_text, t('maps.map_title', :area => map_name)
          client.emit template.render
        end
      end
    end
  end
end
