module AresMUSH
  module Profile
    class SearchCharsRequestHandler
      def handle(request)

        searchGroups = request.args[:searchGroups] || {}
        searchDemographics = request.args[:searchDemographics] || {}
        searchTag = (request.args[:searchTag] || "").strip
                
        chars = Chargen.approved_chars
        
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

        chars.sort_by { |c| c.name }.map { |c| {
                          id: c.id,
                          name: c.name,
                          icon: Website.icon_for_char(c)
                        }}
      end
    end
  end
end