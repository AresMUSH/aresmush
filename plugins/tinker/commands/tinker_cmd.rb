module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler


      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
      #   Character.all.each do |c|
      #     puts "Starting XP: #{c.xp}"
      #     FS3Skills.modify_xp(c, 1)
      #     puts "Ending XP: #{c.xp}"
      #   end

      enactor = enactor

      all_chars = AresCentral.alts_of(enactor)
      puts "CHARS: #{all_chars}"

      my_scenes = []
      all_chars.each do |char|
        char_scenes = Scene.all.select { |s| !s.completed && Scenes.is_watching?(s, char) }.sort_by { |s| s.id }
        my_scenes.concat char_scenes
      end
      client.emit "SCENES #{my_scenes}"

      end

    end
  end
end
