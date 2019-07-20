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
          last_scene = Character.find_one_by_name(char_name).scenes_starring.sort_by { |s| s.created_at }.reverse[0]
          scene_count = Character.find_one_by_name(char_name).scenes_starring.count
          if last_scene
            client.emit "#{last_scene.created_at} - #{char_name} - #{last_scene.title}. #{scene_count} scenes total."
          else
            client.emit "#{char_name}: %xrNONE%xn"
          end
        end
      end

    end
  end
end
