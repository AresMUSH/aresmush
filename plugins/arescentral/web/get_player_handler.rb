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
        
        profile = player.profile.each_with_index.map { |(section, data), index| 
          {
            name: section.titlecase,
            key: section.parameterize(),
            text: Website.format_markdown_for_html(data),
            active_class: index == 0 ? 'active' : ''  # Stupid bootstrap hack
          }
        }
        if (player.handle && !player.handle.profile.blank?)
          handle_profile = "#{player.handle.profile}\n\n----\n*#{t('arescentral.view_full_profile', :name => player.handle.name)}*"
          handle_profile_data = {
            name: "Handle Profile",
            key: "arescentral",
            text: Website.format_markdown_for_html(handle_profile),
            active_class: profile.empty? ? "active" : "" 
          }
          profile << handle_profile_data
        end
        
         {
           id: player.id,
           handle: player.handle ? player.handle.name : nil,
           name: player.name,
           icon: Website.icon_for_char(player),
           alts: player.alts.map { |a| {name: a.name, icon: Website.icon_for_char(a)} },
           can_manage: enactor && Profile.can_manage_char_profile?(enactor, player),
           achievements: Achievements.is_enabled? ? Achievements.build_achievements(player) : nil,
           admin_role_title: player.role_admin_note,
           profile: profile
         }
       end
     end
  end
end