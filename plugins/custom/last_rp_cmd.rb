module AresMUSH
  module Custom
    class LastRPCmd
    # lastrp
      include CommandHandler

      def handle
        client.emit "Date | Name | Handle | Scene Title | Total Scenes"
        chars = Chargen.approved_chars
        chars.each do |c|
          last_scene = c.scenes_starring.sort_by { |s| s.created_at }.reverse[0]
          scene_count = c.scenes_starring.count
          if last_scene
            client.emit "#{last_scene.created_at} | #{c.name} | #{c.handle&.name} | #{last_scene.title} | #{scene_count}"
          else
            client.emit "#{c.name}: %xrNONE%xn"
          end
        end
      end

    end
  end
end
