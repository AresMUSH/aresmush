module AresMUSH
  module Scenes
    class CreateSceneRequestHandler
      def handle(request)
        enactor = request.enactor
        plot = request.args[:plot_id]
        completed = (request.args[:completed] || "").to_bool
        privacy = request.args[:privacy]
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (completed)
          [ :log, :location, :summary, :scene_type, :title, :icdate ].each do |field|
            if (request.args[field].blank?)
              return { error: t('webportal.missing_required_fields') }
            end
          end
        end
        
        scene = Scene.create(
        location: request.args[:location],
        summary: request.args[:summary],
        scene_type: request.args[:scene_type],
        title: request.args[:title],
        icdate: request.args[:icdate],
        shared: completed,
        completed: completed,
        plot: plot.blank? ? nil : Plot[plot],
        private_scene: completed ? false : (privacy == "Private"),
        owner: enactor
        )
          
        Global.logger.debug "Web scene #{scene.id} created by #{enactor.name}."
            
        participant_names = request.args[:participants] || []
      
        participant_names.each do |p|
          participant = Character.find_one_by_name(p.strip)
          if (participant)
            scene.participants.add participant
          end
        end
      
        related_scene_ids = request.args[:related_scenes] || []
      
        # New additions
        related_scene_ids.each do |s|
          related = Scene[s]
          if (related)
            SceneLink.create(log1: scene, log2: related)
          end
        end      
      
        tags = (request.args[:tags] || []).map { |t| t.downcase }.select { |t| !t.blank? }
        scene.update(tags: tags)
      
        if (completed)
          log = SceneLog.create(scene: scene, log: request.args[:log])
          scene.update(scene_log: log)
        end
      
        Scenes.create_scene_temproom(scene)
        
        { id: scene.id }
      end
    end
  end
end