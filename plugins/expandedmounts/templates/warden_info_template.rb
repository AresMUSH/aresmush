module AresMUSH
  module ExpandedMounts
    class WardenInfoTemplate < ErbTemplateRenderer


      attr_accessor :char

      def initialize(char)
        puts "Character: #{char.name} #{char.bonded.name}"
        @char = char
        super File.dirname(__FILE__) + "/warden_info.erb"
      end

      def callsign
        "#{char.demographic(:callsign)&.upcase}:"
      end

    end
  end
end