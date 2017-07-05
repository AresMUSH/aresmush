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
      
      def format_pose(scene_pose)
        colorized = ClientFormatter.format scene_pose.pose
        decolorized = colorized.gsub(/\e\[(\d+)(;\d+)*m/, '')
          
        if (scene_pose.is_system_pose?)
          return "[[span class=\"system\"]]//#{decolorized}//[[/span]]"
        elsif (scene_pose.is_setpose?)
          return decolorized.split(/[\r\n]/).join("\n> ")
        else
          return decolorized
        end
      end
    end
  end
end