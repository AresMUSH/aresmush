module AresMUSH
  module Prefs
    class PrefsTemplate < ErbTemplateRenderer
            
      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/prefs.erb"
      end
      
      def name
        @char.name
      end
      
      def prefs
        @char.prefs || {}
      end
      
      def positive
        prefs.select { |k, v| v['setting'] == '+' }.sort
      end
      
      def negative
        prefs.select { |k, v| v['setting'] == '-' }.sort
      end
      
      def maybe
        prefs.select { |k, v| v['setting'] == '~' }.sort
      end
      
      def note(data)
        return data['note']
      end
      
      def setting(data)
        setting = data['setting']
        case setting
        when "+"
          return "%xg+%xn"
        when "-"
          return "%xr-%xn"
        else
          return "%xy~%xn"
        end
      end
    end
  end
end
