module AresMUSH
  module Prefs
    class PrefsFilterTemplate < ErbTemplateRenderer
            
      attr_accessor :prefs, :category
      
      def initialize(prefs, category)
        @prefs = prefs
        @category = category
        super File.dirname(__FILE__) + "/prefs_filter.erb"
      end
      
      def positive
        @prefs['+']
      end
      
      def negative
        @prefs['-']
      end
      
      def maybe
        @prefs['~']
      end
    end
  end
end
