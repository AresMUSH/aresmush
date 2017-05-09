module AresMUSH
  module Idle
    class RosterDetailTemplate < ErbTemplateRenderer


      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/roster_detail.erb"
      end
      
      def fullname
        @char.demographic(:fullname)
      end
      
      def actor
        @char.actor
      end
      
      def website
        game_site = Global.read_config("game", "website")
        "#{game_site}/char:#{@char.name}"
      end
      
    end
  end
end