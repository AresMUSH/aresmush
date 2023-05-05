module AresMUSH
  module Scenes
    class EditSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
<<<<<<< HEAD

        if (!scene)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request)
        return error if error

        if (!Scenes.can_edit_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end

        Global.logger.info "Scene #{scene.id} edited by #{enactor.name}: #{request.args}."

=======
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!Scenes.can_edit_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Global.logger.info "Scene #{scene.id} edited by #{enactor.name}."
        
>>>>>>> upstream/master
        if (scene.shared)
          [ :log, :location, :summary, :scene_type, :title, :icdate ].each do |field|
            if (request.args[field].blank?)
              return { error: t('webportal.missing_required_fields') }
            end
          end
<<<<<<< HEAD

          Scenes.add_log_version(scene, request.args[:log], enactor)
          Website.add_to_recent_changes('scene', t('scenes.scene_updated', :title => scene.title), { id: scene.id }, enactor.name)

        end

=======
          
          Scenes.add_log_version(scene, request.args[:log], enactor)          
          Website.add_to_recent_changes('scene', t('scenes.scene_updated', :title => scene.title), { id: scene.id }, enactor.name)
          
        end
        
>>>>>>> upstream/master
        scene.update(location: request.args[:location])
        scene.update(summary: Website.format_input_for_mush(request.args[:summary]))
        scene.update(content_warning: request.args[:content_warning])
        scene.update(scene_type: request.args[:scene_type])
        scene.update(scene_pacing: request.args[:scene_pacing])
        scene.update(title: request.args[:title])
        scene.update(icdate: request.args[:icdate])
        scene.update(limit: request.args[:limit])
<<<<<<< HEAD

=======
        
>>>>>>> upstream/master
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
<<<<<<< HEAD

=======
        
>>>>>>> upstream/master
        plots.each do |p|
          existing_link = PlotLink.find_link(p, scene)
          # Plot added - add plot link
          if (!existing_link)
            PlotLink.create(plot: p, scene: scene)
          end
        end
<<<<<<< HEAD

=======
          
>>>>>>> upstream/master
        if (!scene.completed)
          is_private = request.args[:privacy] == "Private"
          scene.update(private_scene: is_private)
          if (is_private)
            scene.watchers.replace []
          end
        end
<<<<<<< HEAD

=======
        
>>>>>>> upstream/master
        participant_names = request.args[:participants] || []
        participant_names_upcase = participant_names.map { |p| p.upcase }
        scene.participants.each do |p|
          if (!participant_names_upcase.include?(p.name_upcase))
            scene.participants.delete p
          end
        end
<<<<<<< HEAD

=======
      
>>>>>>> upstream/master
        participant_names.each do |p|
          participant = Character.find_one_by_name(p.strip)
          if (participant)
            Scenes.add_participant(scene, participant, enactor)
          end
        end
<<<<<<< HEAD

        related_scene_ids = request.args[:related_scenes] || []
        already_related = scene.related_scenes.map { |s| s.id }

=======
      
        related_scene_ids = request.args[:related_scenes] || []
        already_related = scene.related_scenes.map { |s| s.id }
      
>>>>>>> upstream/master
        # New additions
        (related_scene_ids - already_related).each do |s|
          related = Scene[s]
          if (related)
            SceneLink.create(log1: scene, log2: related)
          end
        end
<<<<<<< HEAD

=======
      
>>>>>>> upstream/master
        # Removed
        (already_related - related_scene_ids).each do |s|
          link = scene.find_link(Scene[s])
          if (link)
            link.delete
          end
        end
<<<<<<< HEAD

        Website.update_tags(scene, request.args[:tags])

        creature_ids = request.args[:creatures] || []
        scene.creatures.replace []
        creature_ids.each do |creature|
          creature = Creature.find_one_by_name(creature.strip)
          if (creature)
            if (!scene.creatures.include?(creature))
              Creatures.add_creature_to_scene(scene, creature)
            end
          end
        end

=======
      
        Website.update_tags(scene, request.args[:tags])
      
>>>>>>> upstream/master
        {}
      end
    end
  end
end