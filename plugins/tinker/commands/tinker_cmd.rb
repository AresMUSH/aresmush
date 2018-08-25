module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end





      def handle
        char_name = cmd.args
        char = Character.find_one_by_name(char_name)
        client.emit char
        skills = char.fs3_action_skills.to_a
        skills.each do |s|
          client.emit s.name
          client.emit s.rating
        end


      end



    end
  end
end
