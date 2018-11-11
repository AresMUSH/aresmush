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


        demographics = Demographics.basic_demographics.sort.each.map { |d| 
            {
              name: d.titleize,
              key: d.titleize,
              value: char.demographic(d)
            }
          }
        
        
        demographics << { name: t('profile.age_title'), key: 'Age', value: char.age }
        demographics << { name: t('profile.birthdate_title'), key: 'Birthdate', value: char.demographic(:birthdate)}
        demographics << { name: t('profile.actor_title'), key: 'Actor', value: char.demographic(:actor)}
        
        groups = Demographics.all_groups.keys.sort.map { |g| 
          {
            name: g.titleize,
            value: char.group(g)
          }
        }
        
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
        
        
        scenes_starring = char.scenes_starring
        
        scenes = scenes_starring.sort_by { |s| s.date_shared || s.created_at }.reverse
             .map { |s| {
                      id: s.id,
                      title: s.title,
                      summary: s.summary,
                      location: s.location,
                      icdate: s.icdate,
                      participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: Website.icon_for_char(p) }},
                      scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
                      likes: s.likes
        
                    }
                  }
        #        }
        #      }
        
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
          name: Demographics.name_and_nickname(char),
          all_fields: all_fields,
          fullname: char.demographic(:fullname),
          military_name: Ranks.military_name(char),
          icon: Website.icon_for_char(char),
          profile_image: Website.get_file_info(char.profile_image),
          demographics: demographics,
          groups: groups,
          roster_notes: char.idle_state == 'Roster' ? char.roster_notes : nil,
          handle: char.handle ? char.handle.name : nil,
          status_message: Profile.get_profile_status_message(char),
          tags: char.profile_tags,
          can_manage: enactor && Profile.can_manage_char_profile?(enactor, char),
          profile: profile,
          relationships: relationships,
          scenes: scenes,
          profile_gallery: (char.profile_gallery || {}).map { |g| Website.get_file_info(g) },
          background: show_background ? Website.format_markdown_for_html(char.background) : nil,
          description: Website.format_markdown_for_html(char.description),
          rp_hooks: Website.format_markdown_for_html(char.rp_hooks),
          desc: char.description,
          playerbit: char.is_playerbit?,
          fs3: fs3,
          files: files,
          last_profile_version: char.last_profile_version ? char.last_profile_version.id : nil,
          achievements: Achievements.is_enabled? ? Achievements.build_achievements(char) : nil
        }
      end
      
      
    end
  end
end