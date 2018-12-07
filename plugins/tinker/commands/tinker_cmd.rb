
module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end


      def get_spell_list(list)
        list.to_a.sort_by { |a| a.name }.map { |a|
          {
            name: a.name,
            level: a.level,
            }}
      end

      def get_ability_list(list)
        list.to_a.sort_by { |a| a.name }.map { |a|
          {
            name: a.name,
            rating: a.rating,
            rating_name: a.rating_name
            }}
          end


      def handle
        spells = get_spell_list(enactor.spells_learned)



         client.emit spells

         attributes = get_ability_list(enactor.fs3_attributes)
         client.emit attributes







      end





    end
  end
end
