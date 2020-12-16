module AresMUSH
  module Custom
    class PlayerListCmd
    # playerlist
      include CommandHandler

      def handle
        client.emit "Characters by Handle"
        chars = Chargen.approved_chars
        chars.each do |c|
          last_scene = c.scenes_starring.sort_by { |s| s.created_at }.reverse[0]
          scene_count = c.scenes_starring.count
          if c.handle
            handle = c.handle.name
          else
            handle = "NONE"
          if last_scene
            client.emit " #{handle} (#{c.name}) #{last_scene.created_at} - #{last_scene.title}. #{scene_count} scenes total."
          else
            client.emit "#{handle} (#{c.name}): %xrNONE%xn"
          end
        end
      end

    end
  end
end
