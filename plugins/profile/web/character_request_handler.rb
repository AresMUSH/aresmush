module AresMUSH
  module Profile
    class CharacterRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        enactor = request.enactor

        if (!char)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request, true)
        return error if error



        all_fields = Demographics.build_web_all_fields_data(char, enactor)
        demographics = Demographics.build_web_demographics_data(char, enactor)
        groups = Demographics.build_web_groups_data(char)


                #Spells
                major_school = char.group("Major School")
                minor_school = char.group("Minor School")

                def get_spell_list(list)
                  list.to_a.sort_by { |a| a.level }.map { |a|
                    {
                      name: a.name,
                      level: a.level,
                      school: a.school,
                      learned: a.learning_complete,
                      desc: Website.format_markdown_for_html(Global.read_config("spells", a.name, "desc")),
                      potion: Global.read_config("spells", a.name, "potion"),
                      weapon: Global.read_config("spells", a.name, "weapon"),
                      weapon_specials:  Global.read_config("spells", a.name, "weapon_specials"),
                      armor: Global.read_config("spells", a.name, "armor"),
                      armor_specials: Global.read_config("spells", a.name, "armor_specials"),
                      attack_mod: Global.read_config("spells", a.name, "attack_mod"),
                      lethal_mod: Global.read_config("spells", a.name, "lethal_mod"),
                      spell_mod:  Global.read_config("spells", a.name, "spell_mod"),
                      defense_mod:  Global.read_config("spells", a.name, "defense_mod"),
                      duration: Global.read_config("spells", a.name, "duration"),
                      casting_time: Global.read_config("spells", a.name, "casting_time"),
                      range: Global.read_config("spells", a.name, "range"),
                      area: Global.read_config("spells", a.name, "area"),
                      los: Global.read_config("spells", a.name, "los"),
                      targets: Global.read_config("spells", a.name, "targets"),
                      heal: Global.read_config("spells", a.name, "heal_points"),
                      effect: Global.read_config("spells", a.name, "effect"),
                      damage_type:  Global.read_config("spells", a.name, "damage_type"),
                      available: Global.read_config("spells", a.name, "available"),
                      los:  Global.read_config("spells", a.name, "line_of_sight")
                      }}
                end

                spells = get_spell_list(char.spells_learned)

                spells.each do |s|
                  weapon = Global.read_config("spells", s[:name], "weapon")
                  weapon_specials = Global.read_config("spells", s[:name], "weapon_specials")
                  armor = Global.read_config("spells", s[:name], "armor")
                  armor_specials = Global.read_config("spells", s, "armor_specials")
                  attack = Global.read_config("spells", s[:name], "attack_mod")
                  lethal = Global.read_config("spells", s[:name], "lethal_mod")
                  spell = Global.read_config("spells", s[:name], "spell_mod")
                  defense = Global.read_config("spells", s[:name], "defense_mod")
                  if s[:level] == 8
                    s[:level_8] = true
                    s[:xp] = 13
                  elsif s[:level] == 7
                    s[:xp] = 11
                  elsif s[:level] == 6
                    s[:xp] = 9
                  elsif s[:level] == 5
                    s[:xp] = 9
                  elsif s[:level] == 4
                    s[:xp] = 5
                  elsif s[:level] == 3
                    s[:xp] = 5
                  elsif s[:level] == 2
                    s[:xp] = 3
                  elsif s[:level] == 1
                    s[:xp] = 2
                  end
                  if s[:range] == "Massive"
                    s[:range_desc] = "(2 miles)"
                  elsif s[:range] == "Short"
                    s[:range_desc] = "(10 yards)"
                  elsif s[:range] == "Long"
                    s[:range_desc] = "(100 yards)"
                  end
                  s[:weapon_lethality] = FS3Combat.weapon_stat(weapon, "lethality")
                  s[:weapon_penetration] = FS3Combat.weapon_stat(weapon, "penetration")
                  s[:weapon_type] = FS3Combat.weapon_stat(weapon, "weapon_type")
                  s[:weapon_accuracy] = FS3Combat.weapon_stat(weapon, "accuracy")
                  s[:weapon_shrapnel] = FS3Combat.weapon_stat(weapon, "has_shrapnel")
                  s[:weapon_init] = FS3Combat.weapon_stat(weapon, "init_mod")
                  s[:weapon_damage_type] = FS3Combat.weapon_stat(weapon, "damage_type")
                  if weapon_specials
                    weapon_special = "Spell+#{weapon_specials}"
                    s[:weapon_special_lethality] = FS3Combat.weapon_stat(weapon_special, "lethality")
                    s[:weapon_special_penetration] = FS3Combat.weapon_stat(weapon_special, "penetration")
                    s[:weapon_special_init] = FS3Combat.weapon_stat(weapon_special, "init_mod")
                    s[:weapon_special_accuracy] = FS3Combat.weapon_stat(weapon_special, "accuracy")
                  end
                  if (attack || defense || lethal || spell)
                    s[:mod] = true
                  end
                  protection = FS3Combat.armor_stat(armor, "protection")
                  if protection
                    protection = protection["Chest"]
                  end
                  s[:armor_protection] = protection
                  s[:armor_defense] = FS3Combat.armor_stat(armor, "defense")
                  if s[:targets] == nil

                  elsif s[:targets] == 1
                    s[:single_target] = true
                  elsif s[:targets] > 1
                    s[:multi_target] = true
                  end
                end

                major_spells = []
                spells.each do |s|
                  if (s[:school] == major_school && s[:learned])
                    major_spells.concat [s]
                  end
                end

                if minor_school != "None"
                  minor_spells = []
                  spells.each do |s|
                    if (s[:school] == minor_school && s[:learned])
                      minor_spells.concat [s]
                    end
                  end
                else
                  minor_spells = nil
                end

                other_spells = []
                spells.each do |s|
                  if s[:school] != minor_school && s[:school] != major_school
                    other_spells.concat [s]
                  end
                end

        profile = char.profile.each_with_index.map { |(section, data), index|
          {
            name: section.titlecase,
            key: section.parameterize(),
            text: Website.format_markdown_for_html(data),
            active_class: index == 0 ? 'active' : ''  # Stupid bootstrap hack
          }
        }

        if (char.profile_gallery.empty?)
          gallery_files = Profile.character_page_files(char) || []
        else
          gallery_files = char.profile_gallery.select { |g| g =~ /\w\.\w/ }
        end

        def get_potions(list)
          list.to_a.sort_by { |a| a.name }
            .each_with_index
              .map do |a, i|
                "#{ a.name }"
          end
        end

        potions = get_potions(char.potions_has)

        potions_creating = get_potions(char.potions_creating)

        def get_magic_items(list)
          list.map { |i|
            {
              name: i,
              desc:  Website.format_markdown_for_html(Magic.item_desc(i))
            }}
        end

        magic_items = get_magic_items(char.magic_items)

        def get_comps(list)
          list = list.to_a.sort_by { |c| c.created_at }.reverse
          list[0...10].map { |c|
            {
              from: c.from,
              msg:  Website.format_markdown_for_html(c.comp_msg),
              date: OOCTime.format_date_for_entry(c.created_at)
            }}
        end

        comps = get_comps(char.comps)

        relationships_by_category = Profile.relationships_by_category(char)
        relationships = relationships_by_category.map { |category, relationships| {
          name: category,
          key: category.parameterize(),
          relationships: relationships.sort_by { |name, data| [ data['order'] || 99, name ] }
             .map { |name, data| {
               name: name,
               is_npc: data['is_npc'],
               icon: data['npc_image'] || Website.icon_for_name(name),
               text: Website.format_markdown_for_html(data['relationship'])
             }
           }
        }}

        details = char.details.map { |name, desc| {
          name: name,
          desc: Website.format_markdown_for_html(desc)
        }}
        can_manage = enactor && Profile.can_manage_char_profile?(enactor, char)

        if (char.background.blank?)
          show_background = false
        else
          show_background = can_manage || char.on_roster? || char.bg_shared || Chargen.can_view_bgs?(enactor)
        end

        if char.lore_hook_type == "Item"
          item = char.lore_hook_name ? true : false
        elsif char.lore_hook_type == "Pet"
          pet = char.lore_hook_name ? char.lore_hook_name.gsub(" Pet","") : false
        elsif char.lore_hook_type == "Ancestry"
          ancestry = char.lore_hook_name ? char.lore_hook_name.gsub(" Ancestry","") : false
        end

        files = Profile.character_page_files(char)
        files = files.map { |f| Website.get_file_info(f) }

        if (FS3Skills.is_enabled?)
          fs3 = FS3Skills::CharProfileRequestHandler.new.handle(request)
        else
          fs3 = nil
        end

        if (enactor)
          Login.mark_notices_read(enactor, :achievement)
        end

        {
          id: char.id,
          name: char.name,
          name_and_nickname: Demographics.name_and_nickname(char),
          all_fields: all_fields,
          fullname: char.fullname,
          military_name: Ranks.military_name(char),
          icon: Website.icon_for_char(char),
          profile_image: Website.get_file_info(char.profile_image),
          demographics: demographics,
          groups: groups,
          comps: comps,
          spells: spells,
          major_spells: major_spells,
          minor_spells: minor_spells,
          other_spells: other_spells,
          major_school: major_school,
          minor_school: minor_school,
          magic_items: magic_items,
          potions: potions,
          potions_creating: potions_creating,
          roster_notes: char.idle_state == 'Roster' ? char.roster_notes : nil,
          handle: char.handle ? char.handle.name : nil,
          status_message: Profile.get_profile_status_message(char),
          tags: char.profile_tags,
          can_manage: can_manage,
          profile: profile,
          relationships: relationships,
          last_online: OOCTime.local_long_timestr(enactor, char.last_on),
          profile_gallery: gallery_files.map { |g| Website.get_file_info(g) },
          background: show_background ? Website.format_markdown_for_html(char.background) : nil,
          description: Website.format_markdown_for_html(char.description),
          details: details,
          rp_hooks: char.rp_hooks ? Website.format_markdown_for_html(char.rp_hooks) : '',
          plot_prefs: Website.format_markdown_for_html(char.plot_prefs),
          lore_hook_name: char.lore_hook_name,
          lore_hook_desc: char.lore_hook_desc,
          lore_hook_item: item,
          lore_hook_pet: pet,
          lore_hook_ancestry: ancestry,
          desc: char.description,
          playerbit: char.is_playerbit?,
          fs3: fs3,
          files: files,
          last_profile_version: char.last_profile_version ? char.last_profile_version.id : nil,
          achievements: Achievements.is_enabled? ? Achievements.build_achievements(char) : nil,

          roster: self.build_roster_info(char),
          idle_notes: char.idle_notes ? Website.format_markdown_for_html(char.idle_notes) : nil,

        }
      end

      def build_roster_info(char)
        return nil if !char.on_roster?

        {
          notes: char.roster_notes ? Website.format_markdown_for_html(char.roster_notes) : nil,
          previously_played: char.roster_played,
          app_required: char.roster_restricted,
          contact: char.roster_contact
        }
      end
    end
  end
end
