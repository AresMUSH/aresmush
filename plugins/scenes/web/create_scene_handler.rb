module AresMUSH
  module Scenes
    class CreateSceneRequestHandler
      def handle(request)
        enactor = request.enactor
        plot = request.args[:plot_id]
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: "You are not allowed to create scenes until you're approved." }
        end
        
        [ :log, :location, :summary, :scene_type, :title, :icdate ].each do |field|
          if (request.args[field].blank?)
            return { error: "#{field.to_s.titlecase} is required."}
          end
        end
        
        scene = Scene.create(
        location: request.args[:location],
        summary: request.args[:summary],
        scene_type: request.args[:scene_type],
        title: request.args[:title],
        icdate: request.args[:icdate],
        shared: true,
        completed: true,
        plot: plot.blank? ? nil : Plot[plot],
        owner: enactor
        )
            
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
      
        tags = request.args[:tags] || []
        scene.update(tags: tags.map { |t| t.downcase })
      
        log = SceneLog.create(scene: scene, log: request.args[:log])
        scene.update(scene_log: log)
      
        { id: scene.id }
      end
    end
  end
end