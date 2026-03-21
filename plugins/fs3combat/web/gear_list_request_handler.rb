module AresMUSH
  module FS3Combat
    class GearListRequestHandler
      def handle(request)
        gear_blurb = Global.read_config("fs3combat", "gear_blurb")
        {
          weapons: build_list(FS3Combat.weapons),
          armor: build_list(FS3Combat.armors),
          vehicles: build_list(FS3Combat.vehicles),
          mounts: build_list(FS3Combat.mounts),
          allow_vehicles: FS3Combat.vehicles_allowed?,
          allow_mounts: FS3Combat.mounts_allowed?,
          gear_blurb: gear_blurb.blank? ? nil : Website.format_markdown_for_html(gear_blurb)
        } 
      end
      
      def build_list(hash)
        hash.sort.map { |name, data| {
          key: name,
          name: name.titleize,
          description: data['description']
          }
        }
      end
    end
  end
end


