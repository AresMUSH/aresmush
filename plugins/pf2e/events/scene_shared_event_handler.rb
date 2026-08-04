module AresMUSH
  module Pf2e
    class SceneSharedEventHandler
      def on_event(event)
        scene_id = event.respond_to?(:id) ? event.id : nil
        return unless scene_id

        scene = Scene[scene_id]
        unless scene
          Global.logger.warn "Pf2e SceneSharedEvent: scene #{scene_id} not found."
          return
        end

        result = Pf2e.award_xp_for_shared_scene(scene)
        if result[:ok]
          Global.logger.info "Pf2e scene XP for ##{scene_id}: " \
            "granted=#{result[:granted].inspect} skipped=#{result[:skipped].inspect} " \
            "failed=#{result[:failed].inspect} amount=#{result[:amount]}"
        else
          Global.logger.info "Pf2e scene XP for ##{scene_id}: #{result[:error]}"
        end
      end
    end
  end
end
