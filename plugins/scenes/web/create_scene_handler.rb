module AresMUSH
  module Scenes
    class CreateSceneRequestHandler
      def handle(request)
        enactor = request.enactor
        plot = request.args['plot_id']
        completed = (request.args['completed'] || "").to_bool
        privacy = request.args['privacy'] || "Private"
        log = request.args['log'] || ""
        pacing = request.args['scene_pacing'] || Scenes.scene_pacing.first
        scene_type = request.args['scene_type'] || Scenes.scene_types.first
        tags = (request.args['tags'] || "").split(" ")
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (completed)
          [ 'log', 'location', 'summary', 'scene_type', 'title', 'icdate' ].each do |field|
            if (request.args[field].blank?)
              return { error: t('webportal.missing_required_fields', :fields => "log, location, summary, type, title, date") }
            end
          end
        end
        
        scene = Scene.create(
        location: request.args['location'] || "Somewhere Out There",
        summary: Website.format_input_for_mush(request.args['summary']),
        content_warning: request.args['content_warning'],
        last_activity: Time.now,
        scene_type: scene_type,
        scene_pacing: pacing,
        title: request.args['title'],
        icdate: request.args['icdate'],
        limit: request.args['limit'],
        completed: completed,
        date_completed: completed ? Time.now : nil,
        private_scene: completed ? false : (privacy == "Private"),
        owner: enactor
        )
          
        Global.logger.info "Web scene #{scene.id} created by #{enactor.name}."

        plot_ids = request.args['plots'] || []
        plots = []
        plot_ids.each do |id|
          plot = Plot[id]
          if (plot)
            plots << plot
          end
        end
        
        plots.each do |p|
          PlotLink.create(plot: p, scene: scene)
        end
                    
        participant_names = request.args['participants'] || []
        participants = []
        participant_names.each do |p|
          participant = Character.find_one_by_name(p.strip)
          if (participant)
            Scenes.add_participant(scene, participant, enactor)
            participants << participant
          end
        end
      
        related_scene_ids = request.args['related_scenes'] || []
      
        # New additions
        related_scene_ids.each do |s|
          related = Scene[s]
          if (related)
            SceneLink.create(log1: scene, log2: related)
          end
        end      
      
        Website.update_tags(scene, tags)
      
        if (!log.blank?)
          Scenes.add_to_scene(scene, log, enactor)
        end
        
        if (completed)
          Scenes.share_scene(enactor, scene)
          
          participants.each do |p|
            split_log = log.split
            split_log = split_log[0..split_log.count/participants.count].join(" ")
            Scenes.handle_word_count_achievements(p, split_log)
            Scenes.handle_scene_participation_achievement(p, scene)
          end
          
        else
          Scenes.create_scene_temproom(scene)
          
          scene.watchers.add enactor
          
          scene_data = Scenes.build_live_scene_web_data(scene, enactor).to_json
          alts = AresCentral.play_screen_alts(enactor)
          Global.client_monitor.notify_web_clients(:joined_scene, scene_data, true) do |c|
            c && alts.include?(c)
          end
          
          
        end
      
        
        { id: scene.id }
      end
    end
  end
end