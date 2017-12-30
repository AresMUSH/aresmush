module AresMUSH
  module AresCentral
    class GetPlayerRequestHandler
      def handle(request)
        id = request.args[:id] || ''
        player = Character.find_one_by_name(id)
              
        if (!player)
          return { error: "Not found!"}
        end
        
         {
           handle: player.handle ? player.handle.name : nil,
           name: player.name,
           icon: WebHelpers.icon_for_char(player),
           alts: player.alts.map { |a| {name: a.name, icon: WebHelpers.icon_for_char(a)} }
         }
      end
    end
  end
end