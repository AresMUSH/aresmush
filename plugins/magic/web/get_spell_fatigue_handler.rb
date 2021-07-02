module AresMUSH
  module Magic
    class SpellFatigueRequestHandler

      def handle(request)
        char = request.enactor
        spells = Magic.spell_list_all_data(char.spells_learned)

         {
          major_spells: Magic.major_school_spells(char, spells),
          minor_spells: Magic.minor_school_spells(char, spells),
          other_spells: Magic.other_spells(char, spells),
          major_school: char.group("Major School"),
          minor_school: char.group("Minor School")
        }


      end


    end
  end
end
