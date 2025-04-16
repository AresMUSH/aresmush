module AresMUSH
  module Website
    class SceneListtExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :scenes
                     
      def initialize(scenes)
       @scenes = scenes
        super File.dirname(__FILE__) + "/scene_list.erb"        
      end   
      
      def summary(scene)
        Website.format_markdown_for_html(scene.summary)
      end   
    end
    
    class SceneListMarkdownExtension
      def self.regex
        /\[\[scenelist ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        helper = TagMatchHelper.new(input)
          
        matches = Scene.shared_scenes.select { |p| 
          ((p.content_tags & helper.or_tags).any? && 
          (p.content_tags & helper.exclude_tags).empty?) &&
          (helper.required_tags & p.tags == helper.required_tags)
        }
          
        scenes = matches.sort_by { |m| m.icdate || m.created_at }
        template = SceneListtExtensionTemplate.new(scenes)
        template.render
      end
    end
  end
end