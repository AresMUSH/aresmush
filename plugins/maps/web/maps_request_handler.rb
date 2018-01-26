module AresMUSH
  module Maps
    class MapsRequestHandler
      def handle(request)
        GameMap.all.to_a.sort_by { |m| m.name || "" }.map { |m| {
          id: m.id,
          areas: m.areas,
          name: m.name,
          text: m.map_text
        }}
      end
    end
  end
end


