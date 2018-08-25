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
        skills = {}
        FS3Skills.attrs.map { |a| a['name'] }.each do |a|
          skills[a] = 0
          client.emit a
        end


      end



    end
  end
end
