module AresMUSH
  module Creatures
    class CreaturesRequestHandler
      def handle(request)


        creatures = Creature.all.to_a

        creatures.sort_by { |c| c.name }.map { |c| {
                  id: c.id,
                  name: c.name,
                  sapient: c.sapient,
                  # icon: Website.icon_for_char(c)
                }}

      end
    end
  end
end
