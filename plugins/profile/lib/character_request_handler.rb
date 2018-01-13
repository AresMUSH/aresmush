module AresMUSH
  module Profile
    class CharacterRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        enactor = request.enactor
        
        if (!char)
          return { error: "Character not found!" }
        end

        error = WebHelpers.validate_auth_token(request)
        return error if error
        
        demographics = Demographics.basic_demographics.sort.each.map { |d| 
            {
              name: d.titleize,
              value: char.demographic(d)
            }
          }
        
        if (Ranks.is_enabled?)
          demographics << { name: "Rank", value: char.rank }
        end
          
        demographics << { name: "Age", value: char.age }
        demographics << { name: "Birthdate", value: char.demographic(:birthdate)}
        demographics << { name: "Played By", value: char.demographic(:actor)}
        
        groups = Demographics.all_groups.keys.sort.map { |g| 
          {
            name: g.titleize,
            value: char.group(g)
          }
        }
        
        profile = char.profile.each_with_index.map { |(section, data), index| 
          {
            name: section.titlecase,
            key: section.parameterize('_'),
            text: WebHelpers.format_markdown_for_html(data),
            active_class: index == 0 ? 'active' : ''  # Stupid bootstrap hack
          }
        }
        
        relationships_by_category = Profile.relationships_by_category(char)
        relationships = relationships_by_category.map { |category, relationships| {
          name: category,
          key: category.parameterize('_'),
          relationships: relationships.sort_by { |name, data| [ data['order'] || 99, name ] }
             .map { |name, data| {
               name: name,
               icon: WebHelpers.icon_for_name(name),
               text: WebHelpers.format_markdown_for_html(data['relationship'])
             }
           }
        }}
        
        
        scenes_starring = char.scenes_starring
        #scenes = Scenes.scene_types.map { |type| {
        #  name: type,
        #  key: type.parameterize('_'),
        #  scenes: scenes_starring.select { |s| s.shared && s.scene_type == type }
        
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
        hooks = char.rp_hooks.map { |h| 
          { 
            name: h.name, 
            description: h.description
          }
        }
        
        damage = char.damage.map { |d| {
          date: d.ictime_str,
          description: d.description,
          severity: WebHelpers.format_markdown_for_html(FS3Combat.display_severity(d.initial_severity))
          }          
        }
        
        files = Dir[File.join(AresMUSH.website_uploads_path, "#{char.name.downcase}/**")]
        files = files.map { |f| { name: File.basename(f), path: f.gsub(AresMUSH.website_uploads_path, '') }}
        
        {
          id: char.id,
          name: char.name,
          icon: WebHelpers.icon_for_char(char),
          profile_image: char.profile_image,
          demographics: demographics,
          groups: groups,
          handle: char.handle ? char.handle.name : nil,
          status_message: get_status_message(char),
          tags: char.profile_tags,
          can_manage: enactor && Profile.can_manage_char_profile?(enactor, char),
          profile: profile,
          relationships: relationships,
          scenes: scenes,
          profile_gallery: char.profile_gallery ? char.profile_gallery.split(/[\n ]/) : nil,
          background: show_background ? WebHelpers.format_markdown_for_html(char.background) : nil,
          rp_hooks: hooks.any? ? hooks : nil,
          desc: char.description,
          playerbit: char.is_playerbit?,
          fs3_attrs: get_ability_list(char.fs3_attributes),
          fs3_action_skills: get_ability_list(char.fs3_action_skills),
          fs3_backgrounds: get_ability_list(char.fs3_background_skills),
          fs3_languages: get_ability_list(char.fs3_languages),
          fs3_damage: damage,
          files: files
        }
      end
      
      def get_ability_list(list)
        list.to_a.sort_by { |a| a.name }.map { |a| { name: a.name, rating: a.rating_name }}
      end
      
      def get_status_message(char)
        case char.idle_state
        when "Roster"
          return "This character is on the roster.<br/>#{char.roster_notes}"
        when "Gone"
          return "This character is retired."
        when "Dead"
          return "This character is deceased."
        else
          if (char.is_npc?)
            return "This character is a NPC."
          elsif (char.is_admin?)
            return"This character is a game administrator."
          elsif (char.is_playerbit?)
            return "This character is a player bit."
          elsif (!char.is_approved?)
            return "This character is not yet approved."
          else
            return nil
          end
        end
      end
    end
  end
end