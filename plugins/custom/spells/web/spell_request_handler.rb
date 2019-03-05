module AresMUSH
  module Custom
    class SpellsRequestHandler
      def handle(request)
        spell_list = Global.read_config("spells")
        school = request.args['school'].titlecase || ""
        spell_list = spell_list.select { |name, data|  data['school'] == 'Air' }
        spells = build_list(spell_list)

        {
          spells: spells.group_by { |s| s['level'] }
        }

      end


      def build_list(hash)
        hash.sort.map { |name, data| {
          key: name,
          name: name.titleize,
          desc: data['desc'],
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
          weapon_specials: data['weapon_specials']

          }
        }
      end

    end
  end
end
