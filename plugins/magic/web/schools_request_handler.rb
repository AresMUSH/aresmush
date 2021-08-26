module AresMUSH
  module Magic
    class SchoolsRequestHandler

      def handle(request)
        all_spells = Global.read_config("spells")
        school = request.args['school'].titlecase || ""
        school_spells = all_spells.select { |name, data|  data['school'] == school }
        spells = Magic.spell_list_all_data(school_spells)
        spells_by_level = spells.group_by { |s| s[:level] }
        blurb = Global.read_config("schools", school, "blurb")


        {
          spells: spells_by_level,
          title: school,
          blurb: Website.format_markdown_for_html(blurb),
          pinterest: school
        }

      end




    end
  end
end
