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
        Describe.format_glance_output(char)
      end
      
      def shortdesc(char)
        char.shortdesc ? "#{char.shortdesc}" : ""
      end
    end
  end
end