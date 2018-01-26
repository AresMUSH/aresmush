module AresMUSH
  module Maps
    class MapRequestHandler
      def handle(request)
        id = request.args[:id]
        game_map = GameMap[id]
        
        if (!game_map)
          return { error: "Map not found." }
        end
        
        {
          id: game_map.id,
          areas: game_map.areas,
          name: game_map.name,
          map_text: WebHelpers.format_output_for_html(game_map.map_text)
        }
      end
    end
  end
end


