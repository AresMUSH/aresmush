module AresMUSH
  module Swrifts
    class AttributeListRequestHandler
      def handle(request)
        {
          # weapons: build_list(FS3Combat.weapons),
          # armor: build_list(FS3Combat.armors),
          # vehicles: build_list(FS3Combat.vehicles),
          # mounts: build_list(FS3Combat.mounts),
          # allow_vehicles: FS3Combat.vehicles_allowed?,
          # allow_mounts: FS3Combat.mounts_allowed?
		  # edges: return_hw()
		  edges: build_list(Swrifts.swrifts_edges)
        } 
      end
      
      def build_list(hash)
        hash.name.sort
		return hash
      end

      def return_hw()
		return "Hellow World"
      end
    end
  end
end


