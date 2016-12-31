module AresMUSH
  module Maps
    class MapDeleteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'maps'
        }
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
