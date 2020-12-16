module AresMUSH
  module Custom
    class LastRPCmd
    # lastrp
      include CommandHandler

      def handle
        client.emit "Last RP Scenes for All Characters"
        chars = Chargen.approved_chars
        chars.each do |c|
          char_name = c.name
          last_scene = c.scenes_starring.sort_by { |s| s.created_at }.reverse[0] || "NONE"
          scene_count = c.scenes_starring.count
          client.emit "#{last_scene.created_at} - #{char_name} - #{last_scene.title}. #{scene_count} scenes total."        
        end
      end

    end
  end
end
