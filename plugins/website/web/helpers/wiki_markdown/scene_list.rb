module AresMUSH
  module Website
    class SceneListMarkdownExtension
      def self.regex
        /\[\[scenelist ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        return "" if !input

        helper = TagMatchHelper.new(input)
          
        matches = Scene.all.select { |p| 
          ((p.tags & helper.or_tags).any? && 
          (p.tags & helper.exclude_tags).empty?) &&
          (helper.required_tags & p.tags == helper.required_tags) 
        }
          
        sinatra.erb :"scenes/scene_list", :locals => {
          scenes: matches
        }, :layout => false
      end
    end
  end
end