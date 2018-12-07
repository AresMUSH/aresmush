
module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def build_list(hash)
        hash.sort.map { |name, data| {
          key: name,
          name: name.titleize,
          description: data['description']
          }
        }
      end



      def handle
        specials = AresMUSH::FS3Combat.weapons.keys


         client.emit specials

        specials2 = FS3Combat.mundane_weapons.keys
        client.emit specials2







      end





    end
  end
end
