module AresMUSH
  module Scenes
    class EditSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: "Scene not found." }
        end
        
        error = WebHelpers.validate_auth_token(request)
        return error if error
        
        if (!Scenes.can_access_scene?(enactor, scene))
          return { error: "You are not allowed to edit that scene." }
        end
        
        [ :log, :location, :summary, :scene_type, :title, :icdate ].each do |field|
          if (request.args[field].blank?)
            return { error: "#{field.to_s.titlecase} is required."}
          end
        end
      
        scene.scene_log.update(log: request.args[:log])
        scene.update(location: request.args[:location])
        scene.update(summary: request.args[:summary])
        scene.update(scene_type: request.args[:scene_type])
        scene.update(title: request.args[:title])
        scene.update(icdate: request.args[:icdate])
        scene.update(plot: Plot[request.args[:plot_id]])
            
        participant_names = request.args[:participants] || []
        scene.participants.replace []
      
        participant_names.each do |p|
          participant = Character.find_one_by_name(p.strip)
          if (participant)
            scene.participants.add participant
          end
        end
      
        related_scene_ids = request.args[:related_scenes] || []
        already_related = scene.related_scenes.map { |s| s.id }
      
        # New additions
        (related_scene_ids - already_related).each do |s|
          related = Scene[s]
          if (related)
            SceneLink.create(log1: scene, log2: related)
          end
        end
      
        # Removed
        (already_related - related_scene_ids).each do |s|
          link = scene.find_link(Scene[s])
          if (link)
            link.delete
          end
        end
      
        tags = request.args[:tags] || []
        scene.update(tags: tags.map { |t| t.downcase })
      
        {}
      end
    end
  end
end