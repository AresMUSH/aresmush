module AresMUSH
  module Idle
    class RosterDetailTemplate < ErbTemplateRenderer


      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/roster_detail.erb"
      end
      
      def website
        game_site = Game.web_portal_url
        "#{game_site}/char:#{@char.name}"
      end
      
    end
  end
end