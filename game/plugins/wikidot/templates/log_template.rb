module AresMUSH
  module Wikidot
    class LogTemplate < ErbTemplateRenderer
      
      attr_accessor :log
      
      def initialize(log)
        @log = log
        super File.dirname(__FILE__) + "/log.erb"
      end
      
      def summary
        @log.summary || "TODO: Summary goes here."
      end
      
      def location
        @log.location || "TODO: Location" 
      end
      
      def format_pose(pose)
        colorized = ClientFormatter.format pose
        decolorized = colorized.gsub(/\e\[(\d+)(;\d+)*m/, '')
        decolorized
      end
    end
  end
end