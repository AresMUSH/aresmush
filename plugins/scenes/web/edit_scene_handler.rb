module AresMUSH
  module Scenes
    class EditSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!Scenes.can_edit_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Global.logger.debug "Scene #{scene.id} edited by #{enactor.name}."
        
        if (scene.shared)
          [ :log, :location, :summary, :scene_type, :title, :icdate ].each do |field|
            if (request.args[field].blank?)
              return { error: t('webportal.missing_required_fields') }
            end
          end
          scene.scene_log.update(log: request.args[:log])
          
          Website.add_to_recent_changes('scene', t('scenes.scene_updated', :title => scene.title), { id: scene.id }, enactor.name)
          
        end
        
        scene.update(location: request.args[:location])
        scene.update(summary: Website.format_input_for_mush(request.args[:summary]))
        scene.update(content_warning: request.args[:content_warning])
        scene.update(scene_type: request.args[:scene_type])
        scene.update(scene_pacing: request.args[:scene_pacing])
        scene.update(title: request.args[:title])
        scene.update(icdate: request.args[:icdate])
        scene.update(limit: request.args[:limit])
        
        plot_ids = request.args[:plots] || []
        plots = []
        plot_ids.each do |id|
          plot = Plot[id]
          if (plot)
            plots << plot
          end
        end

        scene.plot_links.each do |link|
          # Plot removed - delete plot link
          if (!plots.any? { |p| link.plot == p })
            link.delete
          end
        end
        
        plots.each do |p|
          existing_link = PlotLink.find_link(p, scene)
          # Plot added - add plot link
          if (!existing_link)
            PlotLink.create(plot: p, scene: scene)
          end
        end
          
        if (!scene.completed)
          is_private = request.args[:privacy] == "Private"
          scene.update(private_scene: is_private)
          if (is_private)
            scene.watchers.replace []
          end
        end
        
        participant_names = request.args[:participants] || []
        participant_names_upcase = participant_names.map { |p| p.upcase }
        scene.participants.each do |p|
          if (!participant_names_upcase.include?(p.name_upcase))
            scene.participants.delete p
          end
        end
      
        participant_names.each do |p|
          participant = Character.find_one_by_name(p.strip)
          if (participant)
            Scenes.add_participant(scene, participant, enactor)
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
      
        tags = (request.args[:tags] || []).map { |t| t.downcase }.select { |t| !t.blank? }
        scene.update(tags: tags.map { |t| t.downcase })
      
        {}
      end
    end
  end
end