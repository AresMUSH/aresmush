module AresMUSH
  module FS3Combat
    class GearDetailRequestHandler
      def handle(request)
        type = request.args[:type]
        name = request.args[:name]

        if (name.blank?)
          return { error: t('fs3combat.invalid_gear_type') }
        end

        case (type || "").downcase
        when "weapon"
          data = FS3Combat.weapon(name)
        when "armor"
          data = FS3Combat.armor(name)
        when "vehicle"
          data = FS3Combat.vehicle(name)
        when "mount"
          data = FS3Combat.mount(name)
        else
          return { error: t('fs3combat.invalid_gear_type') }
        end

        if (!data)
          return { error: t('fs3combat.invalid_gear_type') }
        end
        
        values = data.map { |key, value|  {
          title: key.humanize.titleize,
          detail: Website.format_markdown_for_html(FS3Combat.gear_detail(value).to_s)
          }
        }        
        
        specials = GearSpecialInfo.new(data, type).specials.map { |name, effects| {
          title: name,
          effects: effects
        }}
        
        {
          type: type.titleize,
          name: name.titleize,
          values: values,
          specials: specials
        }
      end
    end
  end
end


