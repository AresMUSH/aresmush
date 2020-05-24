module AresMUSH
  module Profile
    class SearchCharsRequestHandler
      def handle(request)

        search_groups = request.args[:searchGroups] || {}
        search_demographics = request.args[:searchDemographics] || {}
        search_tag = (request.args[:searchTag] || "").strip
        search_name = (request.args[:searchName] || "").strip
        search_relation = (request.args[:searchRelation] || "").strip
        
        chars = Chargen.approved_chars
        
        if (!search_name.blank?)
          chars = chars.select { |c| "#{Demographics.name_and_nickname(c)} #{c.demographic('fullname')}" =~ /#{search_name}/i }
        end
        
        search_groups.each do |group, search|
          next if search.blank?
          search = (search || "").strip

          if (group == "rank" && Ranks.is_enabled?)
            chars = chars.select { |c| c.rank && (c.rank.upcase == search.upcase )}
          else
            chars = chars.select { |c| c.group(group) =~ /\b#{search}\b/i }
          end
        end
        
        search_demographics.each do |demo, search|
          next if search.blank?
          search = (search || "").strip
          chars = chars.select { |c| c.demographic(demo) =~ /\b#{search}\b/i }
        end
        
        if (!search_tag.blank?)
          chars = chars.select { |p| p.profile_tags.include?(search_tag.downcase) }
        end

        if (!search_relation.blank?)
          chars = chars.select { |c| c.relationships.keys.map { |k| k.downcase}.include?(search_relation.downcase) }
        end
        
        chars.sort_by { |c| c.name }.map { |c| {
                          id: c.id,
                          name: c.name,
                          icon: Website.icon_for_char(c)
                        }}
      end
    end
  end
end