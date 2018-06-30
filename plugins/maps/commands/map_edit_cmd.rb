module AresMUSH
  module Maps
    class MapEditCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        map = GameMap.find_one_by_name(self.name)
        if (map)
          Utils.grab client, enactor, "map/update #{self.name}=#{map.map_text}"
        else
          client.emit_failure t('maps.map_not_available', :name => self.name)
        end
      end
    end
  end
end
