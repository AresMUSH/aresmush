module AresMUSH
  module Website
    class CharacterGalleryMarkdownExtension
      def self.regex
        /\[\[chargallery ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        return "" if !input
        
        helper = TagMatchHelper.new(input)
        
        matches = Character.all.select { |c| 
          ((c.profile_tags & helper.or_tags).any? && 
          (c.profile_tags & helper.exclude_tags).empty?) &&
          (helper.required_tags & c.profile_tags == helper.required_tags)
        }
      
        sinatra.erb :"chars/group_list", :locals => {
          chars: matches,
          title: ""
        }, :layout => false
      end
    end
  end
end


