module AresMUSH
  module Website
    class WikiExportSceneTemplate < ErbTemplateRenderer
            
      attr_accessor :scene
      def initialize(scene)
        @scene = scene
        
        super File.dirname(__FILE__) + "/scene.erb"
      end
      
      def summary
        Website.format_markdown_for_html(@scene.summary)
      end
      
      def log
        Website.format_markdown_for_html(@scene.scene_log.log)     
      end
      
      def tags
        (@scene.tags || []).join(", ")
      end
      
      def date_created
        OOCTime.local_short_timestr(nil, @scene.created_at)
      end
      
      def related_scene_filename(related)
        filename = FilenameSanitizer.sanitize(related.title)
        clean_date = "#{related.icdate}".gsub("/", "-")
        "#{clean_date}-#{filename}.html"
      end
    end
  end
end