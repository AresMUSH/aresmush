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
      
      def log
        text = ClientFormatter.format @scene.scene_log.log, false
        text = AnsiFormatter.strip_ansi text
        text = text.gsub('&lt;', '<')
        text = text.gsub('&gt;', '>')
        text
      end
    end
  end
end