module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler


      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        Character.all.each do |c|
          puts "Starting XP: #{c.xp}"
          FS3Skills.modify_xp(c, 1)
          puts "Ending XP: #{c.xp}"
        end

      end

    end
  end
end
