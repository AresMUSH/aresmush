module AresMUSH
  module Roster
    class RosterDetailTemplate < ErbTemplateRenderer

      include TemplateFormatters

      attr_accessor :char, :registry
      
      def initialize(char, registry)
        @char = char
        @registry = registry
        super File.dirname(__FILE__) + "/roster_detail.erb"
      end
      
      def fullname
        Demographics::Api.fullname(@char)
      end
      
      def actor
        @char.actor
      end
      
      def website
        game_site = Global.read_config("game", "website")
        "#{game_site}/#{@char.name}"
      end
      
    end
  end
end