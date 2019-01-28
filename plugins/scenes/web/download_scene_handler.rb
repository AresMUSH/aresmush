module AresMUSH
  module Scenes
    class DownloadSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        if (!scene.shared && !Scenes.can_read_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        text = ""
        
        if (scene.title)
          text << scene.title
          text << "\n"
        end
        text << "Date: #{scene.icdate}\n"
        if (scene.summary)
          text << "Summary: #{scene.summary}\n"
        end
        if (scene.location)
          text << "Location: #{scene.location}\n"
        end
        if (scene.plot)
          text << "Plot: #{scene.plot.title}\n"
        end
        text << "Participants: #{scene.participants.map { |p| p.name }.join(', ')}\n\n"
        
        if (scene.shared)
          text << scene.scene_log.log
        else
          text = scene.poses_in_order.map { |p| p.pose }.join("\n\n")
        end


        formatter = MarkdownFormatter.new
        log = formatter.to_mush(text)
        log.gsub!(/\[\[div ([^\]]*)\]\]/, '')
        log.gsub!(/\[\[\/div\]\]/, '')

        {
          id: scene.id,
          title: scene.date_title,
          log: AresMUSH::MushFormatter.format(log, false)
        }
      end
    end
  end
end