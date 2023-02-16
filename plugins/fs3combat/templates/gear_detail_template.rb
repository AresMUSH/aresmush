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
          special_group = FS3Combat.weapon_stat(@title, "special_group")
          allowed_specials = Global.read_config("fs3combat", "weapon special groups", special_group)
          specials = []

          FS3Combat.weapon_specials.each do |k, v|
            if allowed_specials
              if (allowed_specials.include?(k.downcase))
                desc = v.select { |k, v| k == "description"}
                desc = desc.map { |k, v| "#{v}" }
                special_title = left("%xh#{k}:%xn #{desc[0]}", 40)
                effects = v.select { |k, v| k != "is_magic" && k != "description"}
                effects = effects.map { |k, v|  "#{k.titlecase}: #{v}" }.join("%R%T")
                specials << "%xh#{special_title}%xn%R%T#{effects}"
              end
            end
          end
          specials
        elsif (self.gear_type == :armor)
          special_group = FS3Combat.armor_stat(@title, "special_group")
          allowed_specials = Global.read_config("fs3combat", "armor special groups", special_group)
          specials = []

          FS3Combat.armor_specials.each do |k, v|
            if allowed_specials
              if (allowed_specials.include?(k.downcase))
                desc = v.select { |k, v| k == "description"}
                desc = desc.map { |k, v| "#{v}" }
                special_title = left("%xh#{k}:%xn #{desc[0]}", 40)
                protection = []
                v.dig('protection').each do |k, v|
                  protection.concat ["#{k}: #{v}"]
                end
                protection = protection.join("; ")
                effects = v.select { |k, v| k != "is_magic" && k != "description" && k != "protection"}
                effects = effects.map { |k, v|  "#{k.titlecase}: #{v}" }.join("%R%T")
                specials << "%xh#{special_title}%xn%R%TProtection: #{protection}%R%T#{effects}"
              end
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
