module AresMUSH
  module Magic
    class SpellsRequestHandler

      def handle(request)
        all_spells = Global.read_config("spells")
        spells = Magic.spell_list_all_data(all_spells)

        spells_by_level = spells.group_by { |s| s[:level] }
        {
          spells: spells_by_level,
          title: "All Spells",
        }
      end
    end
  end
end
