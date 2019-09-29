module AresMUSH
  module Scenes
    class DownloadSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        show_ooc = (request.args[:show_ooc] || "false").to_bool
        show_system = (request.args[:show_system] || "true").to_bool
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
        line = "<---------------------------------------"
        
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
            next if (p.is_ooc && !show_ooc)
            next if (p.is_deleted?)
            
            if (p.is_ooc)
              if (show_ooc)
                text << "<OOC> #{p.pose}\n\n"
              end
            elsif (p.is_system_pose?)
              if (show_system)
                text << "<System> #{p.pose}\n\n"
              end
            elsif (p.is_setpose?)
              text << "#{line}\n"
              text << "#{p.pose}\n"
              text << "#{line}\n\n"
            else
              text << "#{p.pose}\n\n"
            end
          end
        end

        
        text.gsub!(/\[\[div class\=\"scene-system-pose\"\]\]/, "<System> #{line}")
        text.gsub!(/\[\[div ([^\]]*)\]\]/, "#{line}")
        text.gsub!(/\[\[\/div\]\]/, "#{line}")
        
        {
          id: scene.id,
          title: scene.date_title,
          log: AnsiFormatter.strip_ansi(MushFormatter.format(text)),
          completed: scene.completed,
          shared: scene.shared
        }
      end
    end
  end
end