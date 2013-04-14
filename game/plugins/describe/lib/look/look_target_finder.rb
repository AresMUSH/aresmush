module AresMUSH
  module Describe
    class LookTargetFinder
      def self.find(args, client)
        target = args.nil? ? t("object.here") : args.target
        Rooms.find_visible_object(target, client) 
      end
    end
  end
end
