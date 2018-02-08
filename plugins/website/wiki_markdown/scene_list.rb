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
          
        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'scene_list.hbs'))

        data = {
          "scenes" => matches.map { |m| {id: m.id, title: m.date_title, summary: m.summary, participant_names: m.participant_names} }
        }
        
        template.render(data)
      end
    end
  end
end