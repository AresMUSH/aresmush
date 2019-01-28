module AresMUSH
  module Profile
    class CharacterGroupsRequestHandler
      def handle(request)
        
        group_key = Global.read_config("website", "character_gallery_group") || "Faction"
        npc_groups = Character.all.select { |c| c.is_npc? && !c.idled_out? }
           .group_by { |c| c.group(group_key) || "" }
        char_groups = Chargen.approved_chars.group_by { |c| c.group(group_key) || "" }
        
        groups = []
        
        char_group_names = char_groups.keys
        npc_group_names = npc_groups.keys
        group_names = char_group_names.concat(npc_group_names).uniq
                
        group_names.each_with_index do |group_name, index|
          npcs_in_group = (npc_groups[group_name] || []).sort_by { |n| n.name }.map { |c| {
              name: c.name,
              icon: Website.icon_for_char(c)
              }
            }
          chars_in_group = char_groups[group_name] || []
          subgroup_key = Global.read_config("website", "character_gallery_subgroup") || "Position"
          group_subgroups = chars_in_group.group_by { |c| c.group(subgroup_key) || "" }.sort
          
          subgroups = []
          
          group_subgroups.each do |subgroup_name, chars_in_subgroup| 
            subgroups << {
              name: subgroup_name,
              chars: chars_in_subgroup.sort_by { |c| c.name }.map { |c| {
                      name: c.name,
                      icon: Website.icon_for_char(c)
                      }
                    }
            }
          end
                                        
          groups << {
            name: group_name,
            key: group_name.parameterize(),
            subgroups: subgroups,
            has_npcs: npcs_in_group.any?,
            npcs: npcs_in_group,
            active_class: index == 0 ? 'active' : ''  # Stupid bootstrap hack
          }
        end
        
        idle_chars = Character.all.select { |c| c.idled_out? }.sort_by { |c| c.name }.map { |c| {
                      name: c.name,
                      icon: Website.icon_for_char(c)
                      }
                    }
        
        {
          group_names: group_names.each_with_index.map { |g, index| {
            name: g,
            key: g.parameterize,
            active_class: index == 0 ? 'active' : ''   # Stupid bootstrap hack
          }},
          groups: groups,
          idle: idle_chars
        }
      end
    end
  end
end