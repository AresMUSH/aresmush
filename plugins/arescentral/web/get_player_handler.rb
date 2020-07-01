module AresMUSH
  module AresCentral
    class GetPlayerRequestHandler
      def handle(request)
        id = request.args[:id] || ''
        player = Character.find_one_by_name(id)
        enactor = request.enactor
              
        if (!player)
          return { error: t('webportal.not_found')}
        end

        error = Website.check_login(request, true)
        return error if error
        
         {
           id: player.id,
           handle: player.handle ? player.handle.name : nil,
           name: player.name,
           icon: Website.icon_for_char(player),
           alts: player.alts.map { |a| {name: a.name, icon: Website.icon_for_char(a)} },
           can_manage: enactor && Profile.can_manage_char_profile?(enactor, player),
           achievements: Achievements.is_enabled? ? Achievements.build_achievements(player) : nil,
           admin_role_title: player.role_admin_note
         }
       end
     end
  end
end