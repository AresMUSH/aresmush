
module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials, :major_spells
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end




      def handle
        spells = []
        char = enactor
        spells_learned = char.spells_learned.select { |l| l.learning_complete }
        spells_learned.each do |s|
          spells << s.name
        end

        client.emit spells




      end





    end
  end
end
