module AresMUSH
  module Wikidot
    class LogTemplate < ErbTemplateRenderer
      
      attr_accessor :scene
      
      def initialize(scene)
        @scene = scene
        super File.dirname(__FILE__) + "/log.erb"
      end
      
      def summary
        @scene.summary || "TODO: Summary goes here."
      end
      
      def location
        @scene.location || "TODO: Location" 
      end
      
      def format_pose(pose)
        colorized = ClientFormatter.format pose
        decolorized = colorized.gsub(/\e\[(\d+)(;\d+)*m/, '')
        decolorized
      end
    end
  end
end