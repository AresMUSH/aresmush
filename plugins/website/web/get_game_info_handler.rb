module AresMUSH
  module Website
    class GetGameInfoRequestHandler
      def handle(request)
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
        
        
        disabled = {}
        Global.read_config('plugins', 'disabled_plugins').each do |p|
          disabled[p] = true
        end
        
        active_scenes = Scene.all.select { |s| !s.completed }
        if (enactor)
          unread_scenes = active_scenes.select { |s| s.participants.include?(enactor) && Scenes.can_read_scene?(enactor, s) && s.is_unread?(enactor) }
          .map { |s| {
            title: s.date_title,
            id: s.id
          }}
        else
          unread_scenes = []
        end
        
        search_id = Global.read_config("secrets", "gcse", "search_id")
        if (search_id.blank?)
          search_id = nil
        end
        
        {
          type: 'game',
          id: 1,
          name: Global.read_config('game', 'name'),
          host: Global.read_config('server', 'hostname'),
          port: Global.read_config('server', 'port'),
          description: Global.read_config('game', 'description'),
          website_welcome: Website.welcome_text,
          ictime: ICTime.ic_datestr(ICTime.ictime),
          scene_start_date: ICTime.ictime.strftime("%Y-%m-%d"),
          unread_scenes_count: unread_scenes.count,
          date_entry_format: Global.read_config("datetime", 'date_entry_format_help').upcase,
          disabled_plugins: disabled,
          extra_plugins: Global.read_config('plugins', 'extras') || [],
          who_count: Who.all_online.count,
          scene_count: active_scenes.count,
          roster_enabled: Idle.roster_enabled?,
          gcse_search_id: search_id
        } 
      end
    end
  end
end