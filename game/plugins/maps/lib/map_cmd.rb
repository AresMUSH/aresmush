module AresMUSH
  module Maps
    class MapCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      
      attr_accessor :area
      
      def want_command?(client, cmd)
        cmd.root_is?("map") && cmd.args
      end
            
      def crack!
        self.area = cmd.args.nil? ? client.room.area : titleize_input(cmd.args)
      end
      
      def handle
        Global.dispatcher.spawn("Reading map.", client) do
          map = map_for_area(self.area)
        
          if (!map)
            client.emit_failure t('maps.no_such_map')
          else
            client.emit BorderedDisplay.text map, t('maps.map_title', :area => self.area)
          end
        end
      end
      
      def map_for_area(area)
        return nil if area.nil?
        matches = Maps.available_maps.select { |m| m.downcase == area.downcase }
        return nil if matches.empty?
        File.read(File.join(Maps.maps_dir, "#{matches[0]}.txt"), :encoding => "UTF-8")
      end
    end
  end
end
