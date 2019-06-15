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

        # Generic demographic/group field list for those who want custom displays.
        all_fields = {}
        Demographics.all_demographics.each do |d|
          all_fields[d] = char.demographic(d)
        end
        Demographics.all_groups.each do |k, v|
          all_fields[k.downcase] = char.group(k)
        end
        all_fields['rank'] = char.rank
        all_fields['age'] = char.age


        demographics = Demographics.visible_demographics(char, enactor).each.map { |d|
            {
              name: d.titleize,
              key: d.titleize,
              value: char.demographic(d)
            }
          }


        demographics << { name: t('profile.age_title'), key: 'Age', value: char.age }

        groups = Demographics.all_groups.keys.sort.map { |g|
          {
            name: g.titleize,
            value: char.group(g)
          }
        }

        #Spells
        major_school = char.group("Major School")
        minor_school = char.group("Minor School")

        def get_spell_list(list)
          list.to_a.sort_by { |a| a.level }.map { |a|
            {
              name: a.name,
              level: a.level,
              school: a.school,
              learned: a.learning_complete
              }}
        end

        spells = get_spell_list(char.spells_learned)

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




        if (Ranks.is_enabled?)
          groups << { name: t('profile.rank_title'), key: 'Rank', value: char.rank }
        end


        profile = char.profile.each_with_index.map { |(section, data), index|
          {
            name: section.titlecase,
            key: section.parameterize(),
            text: Website.format_markdown_for_html(data),
            active_class: index == 0 ? 'active' : ''  # Stupid bootstrap hack
          }
        }

        relationships_by_category = Profile.relationships_by_category(char)
        relationships = relationships_by_category.map { |category, relationships| {
          name: category,
          key: category.parameterize(),
          relationships: relationships.sort_by { |name, data| [ data['order'] || 99, name ] }
             .map { |name, data| {
               name: name,
               icon: Website.icon_for_name(name),
               text: Website.format_markdown_for_html(data['relationship'])
             }
           }
        }}


        show_background = (char.on_roster? || char.bg_shared || Chargen.can_view_bgs?(enactor)) && !char.background.blank?


        files = Profile.character_page_files(char)
        files = files.map { |f| Website.get_file_info(f) }

        if (FS3Skills.is_enabled?)
          fs3 = FS3Skills::CharProfileRequestHandler.new.handle(request)
        else
          fs3 = nil
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
          spells: spells,
          major_spells: major_spells,
          minor_spells: minor_spells,
          other_spells: other_spells,
          major_school: major_school,
          minor_school: minor_school,
          roster_notes: char.idle_state == 'Roster' ? char.roster_notes : nil,
          handle: char.handle ? char.handle.name : nil,
          status_message: Profile.get_profile_status_message(char),
          tags: char.profile_tags,
          can_manage: enactor && Profile.can_manage_char_profile?(enactor, char),
          profile: profile,
          relationships: relationships,
          last_online: OOCTime.local_long_timestr(enactor, char.last_on),
          profile_gallery: (char.profile_gallery || {}).map { |g| Website.get_file_info(g) },
          background: show_background ? Website.format_markdown_for_html(char.background) : nil,
          description: Website.format_markdown_for_html(char.description),
          rp_hooks: Website.format_markdown_for_html(char.rp_hooks),
          plot_prefs: Website.format_markdown_for_html(char.plot_prefs),
          secret_name: char.secret_name,
          secret_summary: char.secret_summary,
          secret_plot: char.secret_plot,
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
