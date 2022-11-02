module AresMUSH
  module ExpandedMounts
    class CharMountRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        enactor = request.enactor

        if (!char)
          return []
        end

        mount = char.bonded

        return mount
      end
    end
  end
end
