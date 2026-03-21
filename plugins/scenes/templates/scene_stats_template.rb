module AresMUSH
  module Scenes
    class SceneStatsTemplate < ErbTemplateRenderer
             
      attr_accessor :stats
                     
      def initialize(stats)
        @stats = stats
        super File.dirname(__FILE__) + "/scene_stats.erb"        
      end
      
      def pacing_breakdown
        @stats[:scenes_by_pacing]
          .map { |k, v| "#{left(k, 20, '.')}#{left(v,6,'.')}(#{sprintf('%.1f', v * 100.0 / stats[:total_scenes])}%)"}
      end
    end
  end
end