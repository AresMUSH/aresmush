module AresMUSH
  module Describe
    # Template for a room.
    class GlanceTemplate < ErbTemplateRenderer
      include CharDescTemplateFields
      
      attr_accessor :room, :enactor
                     
      def initialize(room, enactor)
        @room = room
        @enactor = enactor
        super File.dirname(__FILE__) + "/glance.erb"        
      end
      
      # List of online characters, sorted by name.      
      def online_chars
        @room.characters.select { |c| Login.is_online?(c) }.sort_by { |c| c.name }
      end
      
      def chars
        all_chars = online_chars
        if (@room.scene)
          all_chars.concat @room.scene.participants.to_a
        end
        all_chars.uniq
      end
        
      def glance(char)
        glance_format = Global.read_config("describe", "glance_format")
        glance_args = {
          name: char.name, 
          age: char.age,
          gender_noun: Demographics.gender_noun(char) }
        Demographics.visible_demographics(char, @enactor).each do |k|
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