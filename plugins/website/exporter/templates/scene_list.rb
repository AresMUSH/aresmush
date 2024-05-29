module AresMUSH
  module Website
    class WikiExportSceneListTemplate < ErbTemplateRenderer
            
      attr_accessor :groups
      
      def initialize(groups)
        @groups = groups
        super File.dirname(__FILE__) + "/scene_list.erb"
      end
      
      def scene_page_name(scene)
        WikiExporter.scene_page_name(scene)
      end
    end
  end
end