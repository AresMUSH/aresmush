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
        scene.update(title: request.args[:title])
        scene.update(icdate: request.args[:icdate])
        scene.update(plot: Plot[request.args[:plot_id]])

        if (!scene.completed)
          scene.update(private_scene: request.args[:privacy] == "Private")
          scene.update(watchable_scene: request.args[:privacy] == "Watchable")
          is_private = request.args[:privacy] == "Private"
          scene.update(private_scene: is_private)
          if (is_private)
            scene.watchers.replace []
          end
        end

        participant_names = request.args[:participants] || []
        scene.participants.replace []

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

        creature_ids = request.args[:creatures] || []
        scene.creatures.replace []
        creature_ids.each do |creature|
          creature = Creature.find_one_by_name(creature.strip)
          if (creature)
            if (!scene.creatures.include?(creature))
              Custom.add_creature(scene, creature)
            end
          end
        end

        portal_ids = request.args[:portals] || []
        scene.portals.replace []

        portal_ids.each do |portal|
          portal = Portal.find_one_by_name(portal.strip)
          if (portal)
            if (!scene.portals.include?(portal))
              Custom.add_portal(scene, portal)
            end
          end
        end


        {}
      end
    end
  end
end
