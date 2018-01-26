module AresMUSH
  module AresCentral
    class GetPlayerRequestHandler
      def handle(request)
        id = request.args[:id] || ''
        player = Character.find_one_by_name(id)
        enactor = request.enactor
              
        if (!player)
          return { error: "Not found!"}
        end

        error = WebHelpers.check_login(request, true)
        return error if error
        
         {
           id: player.id,
           handle: player.handle ? player.handle.name : nil,
           name: player.name,
           icon: WebHelpers.icon_for_char(player),
           alts: player.alts.map { |a| {name: a.name, icon: WebHelpers.icon_for_char(a)} },
           can_manage: enactor && Profile.can_manage_char_profile?(enactor, player)
         }
      end
    end
  end
end