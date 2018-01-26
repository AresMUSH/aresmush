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

      def name(char)
        restricted = char.roster_restricted ? "(*)" : ""
        "#{char.name}#{restricted}"
      end
      
      def contact(char)
        restricted = char.roster_restricted ? "(*)" : ""
        "#{char.roster_contact}#{restricted}"
      end
      
      def roster_url
        "#{Game.web_portal_url}/roster"
      end
      
    end
  end
end