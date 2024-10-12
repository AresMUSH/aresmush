module AresMUSH
  module Scenes
    class GetSceneSourceRequestHandler
      def handle(request)
        scene_id = request.args[:scene_id]
        version_id = request.args[:version_id]
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
              
        scene = Scene[scene_id]
        if (!scene)
          return { error: t('webportal.not_found') }
        end

        if (!scene.shared)
          return { error: t('scenes.scene_not_shared') }
        end
	
        version = SceneLog[version_id]
        if (!version)
          return { error: t('webportal.not_found') }
        end
        
        all_versions = scene.sorted_log_versions
        current_index = all_versions.index { |v| v.id == version.id }
        if (!current_index || current_index <= 0)
          diff = ""
        else
          previous = all_versions[current_index - 1]
          diff = Diffy::Diff.new(previous.log, version.log).to_s(:html_simple)
        end
      
        {
          scene_id: scene.id,
          version_id: version.id,
          title: scene.title,
          text: version.log,
          diff: diff,
          created: OOCTime.local_long_timestr(enactor, version.created_at),
          versions: scene.sorted_log_versions.reverse.map { |v| {
            author: v.author_name,
            id: v.id,
            created: OOCTime.local_long_timestr(enactor, v.created_at)
          }}
        }
      end
    end
  end
end