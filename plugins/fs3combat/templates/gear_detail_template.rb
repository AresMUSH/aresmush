module AresMUSH
  module FS3Combat
    class GearDetailTemplate < ErbTemplateRenderer

      attr_accessor :title, :list, :gear_type
      
      def initialize(list, title, gear_type)
        @list = list.sort
        @title = title
        @gear_type = gear_type
        super File.dirname(__FILE__) + "/gear_detail.erb"
      end
      
      def field(data)
        data ? FS3Combat.gear_detail(data) : "---"
      end
      
      def field_name(name)
        t("fs3combat.#{gear_type}_title_#{name}")
      end
      
      def specials
        info = GearSpecialInfo.new(self.list, self.gear_type)
        info.specials.map { |name, effects| "%xh#{left(name, 20)}%xn%R%T#{effects.join("%R%T")}"}
      end
    end
  end
end