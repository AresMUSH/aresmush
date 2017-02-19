module AresMUSH
  module FS3Combat
    class GearListTemplate < ErbTemplateRenderer


      attr_accessor :title, :list
      
      def initialize(list, title)
        @list = list.sort
        @title = title
        super File.dirname(__FILE__) + "/gear_list.erb"
      end
      
      def description(info)
        info["description"] || "---"
      end
    end
  end
end