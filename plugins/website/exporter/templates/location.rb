module AresMUSH
  module Website
    class WikiExportLocationTemplate < ErbTemplateRenderer
            
      attr_accessor :room
      def initialize(room)
        @room = room
        
        super File.dirname(__FILE__) + "/location.erb"
      end
      
      def description
        Website.format_markdown_for_html room.description
      end
     
      def format_desc(desc)
        Website.format_markdown_for_html(desc)
      end
      
      def owners
        @room.room_owners.map { |o| o.name }.join(",")
      end
      
      def area
        @room.area ? @room.area.full_name : ""
      end
    end
  end
end