module AresMUSH
  module Idle
    class RosterRequestHandler
      def handle(request)
                
        group = Global.read_config("website", "character_gallery_group") || "Faction"
        chars = Character.all.select { |c| c.on_roster? }.group_by { |c| c.group(group) || "" }
        
        fields = Global.read_config("idle", "roster_fields").select { |f| f['field'] != 'name' }
        titles = fields.map { |f| f['title'] }
        
        roster = []
        
        chars.each do |group, chars|
          roster << {
            name: group,
            chars: chars.map { |c| build_profile(c, fields) }
          } 
        end
        
        {
          roster: roster,
          titles: titles
        }
      end
      
      def build_profile(char, field_config)
        demographics = {}
        Demographics.visible_demographics(char, nil).each { |d| 
            demographics[d.downcase] = char.demographic(d)
          }
        
        if (Ranks.is_enabled?)
          demographics['rank'] = char.rank
        end
          
        demographics['age'] = char.age
        demographics['birthdate'] = char.demographic(:birthdate)
        
        groups = {}
        
        Demographics.all_groups.keys.sort.each { |g| 
          groups[g.downcase] = char.group(g)  
          }
        
        fields = {}
        field_config.each do |config|
          field = config["field"]
          title = config["title"]
          value = config["value"]

          fields[title] = Profile.general_field(char, field, value)
        end
          
          {
            name: char.name,
            id: char.id,
            military_name: Ranks.is_enabled? ? Ranks.military_name(char) : char.fullname,
            fields: fields,
            icon: Website.icon_for_char(char),
            roster_notes: Website.format_markdown_for_html(char.roster_notes || ""),
            previously_played: char.roster_played,
            app_required: Idle.roster_app_required?(char),
            contact: char.roster_contact,
            groups: groups,
            demographics: demographics,
        }        
      end
      
    end
  end
end