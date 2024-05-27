module AresMUSH
  module Website
    class WikiExportSceneIndexTemplate < ErbTemplateRenderer
            
      attr_accessor :groups
      
      def initialize(groups)
        @groups = groups
        super File.dirname(__FILE__) + "/scene_index.erb"
      end
      
      def page_name(scene)
        WikiExporter.scene_page_name(scene)
      end
    end
  end
end