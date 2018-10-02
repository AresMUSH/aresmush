
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
        char = enactor
        spell_names = char.spells_learned.map { |s| s.name }
        list = spell_names.join " "
        potion = list.include?("Potions")
        client.emit spell_names
        client.emit list
        client.emit potion
      end





    end
  end
end
