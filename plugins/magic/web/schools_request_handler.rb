module AresMUSH
  module Magic
    class SchoolsRequestHandler

      def handle(request)
        all_spells = Global.read_config("spells")
        school = request.args['school'].titlecase || ""
        school_spells = all_spells.select { |name, data|  data['school'] == school }
        spells = Magic.spell_list_all_data(school_spells)

        spells_by_level = spells.group_by { |s| s[:level] }
        blurb = Global.read_config("magic", "schools", school)['blurb']


        {
          spells: spells_by_level,
          title: school,
          blurb: Website.format_markdown_for_html(blurb),
          pinterest: school
        }

      end


      def build_list(hash)
        hash.sort.map { |name, data| {
          key: name,
          name: name.titleize,
          desc: Website.format_markdown_for_html(data['desc']),
          available: data['available'],
          level: data['level'],
          school: data['school'],
          potion: data['is_potion'],
          duration: data['duration'],
          casting_time: data['casting_time'],
          range: data['range'],
          area: data['area'],
          los: data['line_of_sight'],
          targets: data['target_num'],
          heal: data['heal_points'],
          defense_mod: data['defense_mod'],
          attack_mod: data['attack_mod'],
          lethal_mod: data['lethal_mod'],
          spell_mod: data['spell_mod'],
          weapon: data['weapon'],
          armor: data['armor'],
          armor_specials: data['armor_specials'],
          weapon_specials: data['weapon_specials'],
          effect: data['effect'],
          damage_type: data['damage_type']

          }
        }
      end

    end
  end
end
