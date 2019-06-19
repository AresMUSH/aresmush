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
        line = "&lt;---------------------------------------"
        
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
          text = ""
          scene.poses_in_order.each do |p|
            next if (p.is_ooc)
            next if (p.is_deleted?)
            
            if (p.is_system_pose?)
              text << "&lt;System&gt; #{p.pose}\n\n"
            elsif (p.is_setpose?)
              text << "#{line}\n"
              text << "#{p.pose}\n"
              text << "#{line}\n\n"
            else
              text << "#{p.pose}\n\n"
            end
          end
        end


        formatter = MarkdownFormatter.new
        log = formatter.to_mush(text)
        log.gsub!(/\[\[div class\=\"scene-system-pose\"\]\]/, "&lt;System&gt; #{line}\n")
        log.gsub!(/\[\[div ([^\]]*)\]\]/, '')
        log.gsub!(/\[\[\/div\]\]/, "#{line}\n")

        {
          id: scene.id,
          title: scene.date_title,
          log: AresMUSH::MushFormatter.format(log)
        }
      end
    end
  end
end