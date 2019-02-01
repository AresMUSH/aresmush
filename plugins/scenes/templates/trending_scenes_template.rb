module AresMUSH
  module Scenes
    class TrendingScenesTemplate < ErbTemplateRenderer
             
      attr_accessor :scenes
                     
      def initialize(scenes)
        @scenes = scenes
        super File.dirname(__FILE__) + "/trending_scenes.erb"        
      end
    end
  end
end