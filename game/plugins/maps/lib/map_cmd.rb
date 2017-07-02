module AresMUSH
  module Maps
    class MapCmd
      include CommandHandler
      
      attr_accessor :area
      
      def parse_args
        self.area = !cmd.args ? enactor_room.area : titlecase_arg(cmd.args)
      end
      
      def handle
        map = Maps.get_map_for_area(self.area)
      
        if (!map)
          client.emit_failure t('maps.no_such_map', :name => self.area)
        else
          template = BorderedDisplayTemplate.new map.map_text, t('maps.map_title', :area => self.area)
          client.emit template.render
        end
      end
    end
  end
end
