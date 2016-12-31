module AresMUSH
  module Maps
    class MapCmd
      include CommandHandler
      
      attr_accessor :area
      
      def crack!
        self.area = !cmd.args ? enactor_room.area : titleize_input(cmd.args)
      end
      
      def handle
        map = Maps.get_map_for_area(self.area)
      
        if (!map)
          client.emit_failure t('maps.no_such_map', :name => self.area)
        else
          client.emit BorderedDisplay.text map.map_text, t('maps.map_title', :area => self.area)
        end
      end
    end
  end
end
