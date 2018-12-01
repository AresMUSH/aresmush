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
        glance_format = Global.read_config("describe", "glance_format")
        glance_args = {
          name: char.name, 
          age: char.age,
          gender_noun: Demographics.gender_noun(char) }
        Demographics.basic_demographics.each do |k|
          glance_args[k.downcase.to_sym] = (char.demographic(k) || "-").downcase
          glance_args["#{k.downcase}_title".to_sym] = (char.demographic(k) || "-").titlecase
        end
        output = (glance_format % glance_args) || ""
        output
      end
      
      def shortdesc(char)
        char.shortdesc ? "#{char.shortdesc}" : ""
      end
    end
  end
end