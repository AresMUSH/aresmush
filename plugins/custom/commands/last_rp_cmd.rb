module AresMUSH
  module Custom
    class LastRPCmd
    # lastrp
      include CommandHandler

      def handle
        client.emit "Last RP Scenes for All Characters"
        chars = Chargen.approved_chars
        chars.each do |c|
          last_scene = c.scenes_starring.sort_by { |s| s.created_at }.reverse[0] || "NONE"
          scene_created = last_scene.created_at || "N/A"
          scene_count = c.scenes_starring.count
          scene_title = last_scene.title || "N/A"
          client.emit "#{scene_created} - #{c.name} - #{scene_title}. #{scene_count} scenes total."
        end
      end

    end
  end
end
