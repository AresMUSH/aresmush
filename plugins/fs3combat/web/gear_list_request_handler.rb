module AresMUSH
  module FS3Combat
    class GearListRequestHandler
      def handle(request)
        {
          weapons: build_list(Magic.mundane_weapons),
          armor: build_list(Magic.mundane_armors),
          vehicles: build_list(FS3Combat.vehicles),
          mounts: build_list(FS3Combat.mounts),
          allow_vehicles: FS3Combat.vehicles_allowed?,
          allow_mounts: FS3Combat.mounts_allowed?
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


