
module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials, :major_spells
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def get_spell_list(list)
        list.to_a.sort_by { |a| a.level }.map { |a|
          {
            name: a.name,
            level: a.level,
            school: a.school
            }}
      end



      def handle
        char = enactor
        spells = get_spell_list(char.spells_learned)

        spells.each do |s|
          client.emit s.name
        end

        major_school = char.group("Major School")

        minor_school = char.group("Minor School")

        major_spells_list = []
        spells.each do |s|
          if s[:school] == major_school
            major_spells_list.concat [s]
          end
        end
        client.emit major_spells_list

        # major_spells = get_spell_list(major_spells_list)

        major_spells_list.each do |s|
          client.emit s.name
        end





      end





    end
  end
end
