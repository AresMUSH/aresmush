module AresMUSH
  module Profile
    class SearchCharsRequestHandler
      def handle(request)

        searchGroups = request.args[:searchGroups] || {}
        searchDemographics = request.args[:searchDemographics] || {}
        searchTag = (request.args[:searchTag] || "").strip
        searchName = (request.args[:searchName] || "").strip
        searchRelation = (request.args[:searchRelation] || "").strip
        
        chars = Chargen.approved_chars
        
        if (!searchName.blank?)
          chars = chars.select { |c| "#{Demographics.name_and_nickname(c)} #{c.demographic('fullname')}" =~ /#{searchName}/i }
        end
        
        searchGroups.each do |group, search|
          next if search.blank?
          search = (search || "").strip

          if (group == "rank" && Ranks.is_enabled?)
            chars = chars.select { |c| c.rank && (c.rank.upcase == search.upcase )}
          else
            chars = chars.select { |c| c.group(group) =~ /\b#{search}\b/i }
          end
        end
        
        searchDemographics.each do |demo, search|
          next if search.blank?
          search = (search || "").strip
          chars = chars.select { |c| c.demographic(demo) =~ /\b#{search}\b/i }
        end
        
        if (!searchTag.blank?)
          chars = chars.select { |p| p.profile_tags.include?(searchTag.downcase) }
        end

        if (!searchRelation.blank?)
          chars = chars.select { |c| c.relationships.keys.map { |k| k.downcase}.include?(searchRelation.downcase) }
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