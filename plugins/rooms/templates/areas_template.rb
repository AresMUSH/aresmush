module AresMUSH
  module Rooms
    class AreasTemplate < ErbTemplateRenderer
                                  
      def initialize
        super File.dirname(__FILE__) + "/areas.erb"        
      end
      
      def top_level_areas
        Rooms.top_level_areas
      end
      
      def children(area, indent_str)
        kids = area.sorted_children
        if kids.empty?
          return nil
        else
          new_indent = "  #{indent_str}"
          kids.map { |a| "%R#{indent_str}- #{a.name}#{children(a, new_indent)}"}.join("")
        end
      end
    end
  end
  
end