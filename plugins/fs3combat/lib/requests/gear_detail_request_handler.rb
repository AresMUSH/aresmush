module AresMUSH
  module FS3Combat
    class GearDetailRequestHandler
      def handle(request)
        type = request.args[:type]
        name = request.args[:name]

        if (name.blank?)
          return { error: "Invalid gear type." }
        end

        case (type || "").downcase
        when "weapon"
          data = FS3Combat.weapon(name)
        when "armor"
          data = FS3Combat.armor(name)
        when "vehicle"
          data = FS3Combat.vehicle(name)
        else
          return { error: "Invalid gear type." }
        end

        values = data.map { |key, value|  {
          title: key.titleize,
          detail: WebHelpers.format_markdown_for_html(FS3Combat.gear_detail(value).to_s)
          }
        }
        
        {
          type: type.titleize,
          name: name.titleize,
          values: values
        }
      end
    end
  end
end


