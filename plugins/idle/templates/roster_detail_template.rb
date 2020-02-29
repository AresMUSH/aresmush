module AresMUSH
  module Idle
    class RosterDetailTemplate < ErbTemplateRenderer


      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/roster_detail.erb"
      end
      
      def app_template
        Global.read_config("idle", "roster_app_template")
      end
      
      def website
        game_site = Game.web_portal_url
        "#{game_site}/char:#{@char.name}"
      end
      
      def app_required
        Idle.roster_app_required?(@char)
      end
    end
  end
end