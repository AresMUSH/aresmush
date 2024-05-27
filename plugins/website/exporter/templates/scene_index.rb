module AresMUSH
  module Website
    class WikiExportSceneIndexTemplate < ErbTemplateRenderer
            
      attr_accessor :scene_block, :plots
      
      def initialize(scene_block, plots)
        @scene_block = scene_block
        @plots = plots
        super File.dirname(__FILE__) + "/scene_index.erb"
      end
      
      def plot_summary(plot)
        Website.format_markdown_for_html(plot.summary)
      end
      
    end
  end
end