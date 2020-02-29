module AresMUSH
  module Idle
    class RosterListTemplate < ErbTemplateRenderer
      
      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + '/roster_list.erb'
      end
            
      def approved(char)
        char.is_approved? ? t('global.y') : t('global.n')
      end
      
      def roster_url
        "#{Game.web_portal_url}/roster"
      end
      
      def fields
        Global.read_config("idle", "roster_fields")
      end      
      
      def show_field(char, field_config)
        field = field_config["field"]
        value = field_config["value"]
        width = field_config["width"]
        
        field_eval = Profile.general_field(char, field, value)
        left(field_eval, width)
      end
      
      def show_title(field_config)
        title = field_config["title"]
        width = field_config["width"]
        
        left(title, width)
      end
      
      def demographic(char, value)
        char.demographic(value)
      end
      
      def name(char)
        Demographics.name_and_nickname(char)
      end
      
      def app_required(char)
        Idle.roster_app_required?(char) ? "(*)" : ""
      end
      
      def group(char, value)
        char.group(value)
      end
      
    end
  end
end