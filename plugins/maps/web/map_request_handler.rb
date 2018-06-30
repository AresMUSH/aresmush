module AresMUSH
  module Maps
    class MapRequestHandler
      def handle(request)
        id = request.args[:id]
        game_map = GameMap[id]
        
        if (!game_map)
          return { error: t('webportal.not_found') }
        end

        {
          id: game_map.id,
          areas: game_map.area_names,
          name: game_map.name,
          map_text: WebHelpers.format_markdown_for_html(game_map.map_text)
        }
      end
    end
  end
end


