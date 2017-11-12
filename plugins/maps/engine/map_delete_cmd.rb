module AresMUSH
  module Maps
    class MapDeleteCmd
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
          map.delete
          client.emit_success t('maps.map_deleted', :name => self.name)
        else
          client.emit_failure t('maps.map_not_available', :name => self.name)
        end
      end
    end
  end
end
