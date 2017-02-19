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
        if (self.gear_type == :weapon)
          allowed_specials = []
          self.list.each do |fields|
            if (fields[0] == "allowed_specials")
              allowed_specials = fields[1]
            end
          end
          
          specials = []
          FS3Combat.weapon_specials.each do |k, v|
            if (allowed_specials.include?(k))
              special_title = left("#{k}:", 20)
              effects = v.map { |k, v|  "#{k.titlecase}: #{v}" }.join("%R%T")
              specials << "%xh#{special_title}%xn%R%T#{effects}"
            end
          end
          specials
        else
          []
        end
      end
    end
  end
end