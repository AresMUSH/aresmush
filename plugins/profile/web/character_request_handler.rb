module AresMUSH
  module Profile
    class CharacterRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        enactor = request.enactor
        
        if (!char)
          return { error: t('webportal.not_found') }
        end

        error = WebHelpers.check_login(request, true)
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
              name: t("profile.#{d.downcase}_title"),
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
          

        kills = char.kills.to_a.sort_by { |k| k.scene.icdate }.each_with_index.map { |k, i| {
                                                                                       name: k.victory,
                                                                                       date: k.scene.icdate,
                                                                                       scene: {
                                                                                         id: k.scene.id,
                                                                                         title: k.scene.title
                                                                                       },
                                                                                       index: i + 1
                                                                                     }
        }
          
        profile = char.profile.each_with_index.map { |(section, data), index| 
          {
            name: section.titlecase,
            key: section.parameterize(),
            text: WebHelpers.format_markdown_for_html(data),
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
               icon: WebHelpers.icon_for_name(name),
               text: WebHelpers.format_markdown_for_html(data['relationship'])
             }
           }
        }}
        
        
        scenes_starring = char.scenes_starring
        
        scenes = scenes_starring.select { |s| s.shared }.sort_by { |s| s.date_shared || s.created_at }.reverse
             .map { |s| {
                      id: s.id,
                      title: s.title,
                      summary: s.summary,
                      location: s.location,
                      icdate: s.icdate,
                      participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: WebHelpers.icon_for_char(p) }},
                      scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
                      likes: s.likes
        
                    }
                  }
        #        }
        #      }
        
        show_background = (char.on_roster? || char.bg_shared) && !char.background.blank?
        damage = char.damage.map { |d| {
          date: d.ictime_str,
          description: d.description,
          severity: WebHelpers.format_markdown_for_html(FS3Combat.display_severity(d.initial_severity))
          }          
        }
        
        files = Dir[File.join(AresMUSH.website_uploads_path, "#{char.name.downcase}/**")]
        files = files.map { |f| WebHelpers.get_file_info(f) }
        
        {
          id: char.id,
          name: char.name,
          all_fields: all_fields,
          fullname: char.demographic(:fullname),
          military_name: Ranks.military_name(char),
          icon: WebHelpers.icon_for_char(char),
          profile_image: WebHelpers.get_file_info(char.profile_image),
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
          profile_gallery: (char.profile_gallery || {}).map { |g| WebHelpers.get_file_info(g) },
          background: show_background ? WebHelpers.format_markdown_for_html(char.background) : nil,
          rp_hooks: WebHelpers.format_markdown_for_html(char.rp_hooks),
          desc: char.description,
          playerbit: char.is_playerbit?,
          fs3_attributes: get_ability_list(char.fs3_attributes),
          fs3_action_skills: get_ability_list(char.fs3_action_skills),
          fs3_backgrounds: get_ability_list(char.fs3_background_skills),
          fs3_languages: get_ability_list(char.fs3_languages),
          fs3_damage: damage,
          files: files,
          kills: kills,
          awards: setup_awards(char),
          last_profile_version: char.last_profile_version ? char.last_profile_version.id : nil
        }
      end
      
      def get_ability_list(list)        
        list.to_a.sort_by { |a| a.name }.map { |a| 
          { 
            name: a.name, 
            rating: a.rating, 
            rating_name: a.rating_name
          }}
      end



      def setup_awards(char)
        medals = char.awards.to_a
        
        campaign = medals.select { |a| a.award =~ /Campaign Medal/ }
        campaign.each { |c| medals.delete(c) }

        badges = medals.select { |a| a.award =~ /(Badge|Wings)/ }
        badges.each { |b| medals.delete(b) }
        badge_names = badges.map { |b| b.award }
        badge_display = []

        if (char.group("Department") == "Marines")
          badge_names << "Colonial Warrior Badge"
        end

        if (char.group("Department") == "Air Wing")
          badge_names << "Pilot Wings"
        end

        if (char.group("Position") == "Raptor ECO")
          badge_names << "Electronic Warfare Badge"
        end

        [ "Pilot Wings", "Electronic Warfare Badge", "Colonial Warrior Badge" ].each do |name|
          [ "Master ", "Expert ", "" ].each do |level|
            fullname = "#{level}#{name}"
            if badge_names.include?(fullname)
              badge_display << fullname
              break
            end
          end
        end

        [ "Sniper Badge", "Expert Marksman Badge", "Marksman Badge" ].each do |w|
          if badge_names.include?(w)
            badge_display << w
            break
          end
        end
        
        [ "Combat Medical Badge", "Aerospace Combat Badge", "Ground Combat Badge" ].each do |name|
          [ "Gold ", "" ].each do |level|
            fullname = "#{level}#{name}"
            if badge_names.include?(fullname)
              badge_display << fullname
              break
            end
          end
        end
        
        sac = 0
        if (char.damage.count > 0)
          last_award_ceremony = "2237-11-16"
          prior_damage = char.damage.select { |d| DateTime.strptime(d.ictime_str, '%m/%d/%Y') < DateTime.parse(last_award_ceremony) }
          sac = prior_damage.group_by { |d| d.ictime_str }.count
        end
        
        award_priorities = [ "Legion Of Kobol", "Phoenix Cross", "Gold Cluster", "Silver Cluster", "Distinguished Marine Medal", "Distinguished Navy Medal", "Distinguished Aerospace Medal" ]
        
        campaign_images = campaign.map { |c| "#{c.award.downcase.gsub(" ", "-")}.png" }
        medal_images = medals.group_by { |m| m.award }
                       .sort_by { |name, awards| award_priorities.index(name) || 9 }
                       .map { |name, awards| "#{name}#{awards.count > 1 ? awards.count : '' }.png".downcase.gsub(" ", "-") }
        medal_images << "meritorious-unit-citation.png"
        badge_images = badge_display.map { |b| "#{b}.png".downcase.gsub(" ", "-") }
        
        citations = medals.group_by { |m| m.award }
                    .sort_by { |name, awards| award_priorities.index(name) || 9 }
                    .map { |name, awards| { name: name, citations: awards.select { |a| a.citation }.map { |a| a.citation } } }
        
        badges.group_by { |m| m.award }
          .sort_by { |name, awards| name }
          .each do |name, awards|
          citations << { name: name, citations: awards.select { |a| a.citation}.map { |a| a.citation} }
        end
        
        if ( sac > 0)
          if (sac > 16)
            n = sac / 16
            n.times.each { |x| medal_images << "sacrifice16.png" }
            sac = sac - (n * 16)
          end
          
          medal_images << "sacrifice#{sac}.png"
      end
      
      {
        badge_images: badge_images,
        medal_images: medal_images,
        campaign_images: campaign_images,
        citations: citations
      }
    end
    end
  end
end
