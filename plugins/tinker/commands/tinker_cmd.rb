
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
        spell_names = char.spells_learned
        values = spell_names.map {|x| x.name}
        names = values.to_s
        potions = values.any?("Potions")


        client.emit values.to_s
        client.emit potions
      end




    end
  end
end
