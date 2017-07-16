module AresMUSH
  module Wikidot
    class LogTemplate < ErbTemplateRenderer
      
      attr_accessor :scene
      
      def initialize(scene)
        @scene = scene
        super File.dirname(__FILE__) + "/log.erb"
      end
      
      def summary
        @scene.summary
      end
      
      def location
        @scene.location
      end
      
      def format_pose(scene_pose)
        colorized = ClientFormatter.format scene_pose.pose
        decolorized = colorized.gsub(/\e\[(\d+)(;\d+)*m/, '')
          
        if (scene_pose.is_system_pose?)
          return decolorized.split(/[\r\n]/).map { |d| "[[span class=\"system\"]]//#{d}//[[/span]]" }.join("\n")
        elsif (scene_pose.is_setpose?)
          decolorized = decolorized.split(/[\r\n]/).join("\n> ")
          return "> #{decolorized}"
        else
          return decolorized
        end
      end
    end
  end
end