module AresMUSH
  module Website
    class WikiExportPlotTemplate < ErbTemplateRenderer
            
      attr_accessor :plot
      def initialize(plot)
        @plot = plot
        
        super File.dirname(__FILE__) + "/plot.erb"
      end
      
      def summary
        Website.format_markdown_for_html(@plot.summary)
      end
      
      def details
        Website.format_markdown_for_html(@plot.description) 
      end
      
      def tags
        (@plot.content_tags || []).join(", ")
      end
      
      def storytellers
        @plot.storytellers.to_a.join(", ")
      end
      
      def scene_page_name(scene)
        WikiExporter.scene_page_name(scene)
      end
    end
  end
end