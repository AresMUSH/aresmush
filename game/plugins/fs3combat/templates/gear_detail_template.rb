module AresMUSH
  module FS3Combat
    class GearDetailTemplate < ErbTemplateRenderer

      include TemplateFormatters

      attr_accessor :title, :list
      
      def initialize(list, title)
        @list = list.sort
        @title = title
        super File.dirname(__FILE__) + "/gear_detail.erb"
      end
      
      def field(data)
        data ? FS3Combat.gear_detail(data) : "---"
      end
    end
  end
end