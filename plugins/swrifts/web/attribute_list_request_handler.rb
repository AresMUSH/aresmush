module AresMUSH
  module Swrifts
    class AttributeListRequestHandler
      def handle(request)
      {
		  edges: build_list(Swrifts.swrifts_edges),
		  hinderances: build_list(Swrifts.swrifts_hinderances),
		  iconicf: build_list(Swrifts.swrifts_icf),
		  race: build_list(Swrifts.swrifts_races),
		  skills: build_list(Swrifts.swrifts_skills),
      swabilities: build_list(Swrifts.swrifts_swabilities)
      #swabilities: return_hw()
      }
      end

      def build_list(hash)
        return "Hewlllso"
        nh = hash.sort_by { |a| a['name'] }
		    return nh
      end

      def return_hw()
		return "Hellow World"
      end
    end
  end
end
