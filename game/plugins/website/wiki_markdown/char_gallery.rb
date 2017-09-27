module AresMUSH
  module Website
    class CharacterGalleryMarkdownExtension
      def self.regex
        /\[\[chargallery ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        tags = (input || "").split(" ")
      
        or_tags = tags.select { |tag| !tag.start_with?("-") && !tag.start_with?("+")}
         
        required_tags = tags.select { |tag| tag.start_with?("+") }
        .map { |tag| tag.after("+") }
         
        exclude_tags = tags.select { |tag| tag.start_with?("-") }
        .map { |tag| tag.after("-") }
      
        matches = Character.all.select { |c| 
          ((c.profile_tags & or_tags).any? && 
          (c.profile_tags & exclude_tags).empty?) &&
          (required_tags & c.profile_tags == required_tags)
        }
      
        sinatra.erb :"chars/group_list", :locals => {
          chars: matches,
          title: ""
        }
      end
    end
  end
end


