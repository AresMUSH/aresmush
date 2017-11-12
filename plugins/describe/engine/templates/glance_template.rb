module AresMUSH
  module Describe
    # Template for a room.
    class GlanceTemplate < ErbTemplateRenderer
      include CharDescTemplateFields
      
      attr_accessor :room
                     
      def initialize(room)
        @room = room
        super File.dirname(__FILE__) + "/glance.erb"        
      end
      
      # List of online characters, sorted by name.      
      def online_chars
        @room.characters.select { |c| Login.is_online?(c) }.sort_by { |c| c.name }
      end
        
      def glance(char)
        height = char.demographic(:height) || "-"
        eyes = char.demographic(:eyes) || "-"
        hair = char.demographic(:hair) || "-"
        t('describe.glance', :height => height.titlecase,
          :gender => Demographics.gender_noun(char),
          :age => char.age,
          :hair => hair.downcase,
          :eyes => eyes.downcase)
      end
      
      def shortdesc(char)
        char.shortdesc ? "#{char.shortdesc.description}" : ""
      end
    end
  end
end