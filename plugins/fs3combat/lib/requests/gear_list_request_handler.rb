module AresMUSH
  module FS3Combat
    class GearListRequestHandler
      def handle(request)
        {
          weapons: build_list(FS3Combat.weapons),
          armor: build_list(FS3Combat.armors),
          vehicles: build_list(FS3Combat.vehicles)
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


