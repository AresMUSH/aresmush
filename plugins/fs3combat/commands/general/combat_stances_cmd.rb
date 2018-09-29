module AresMUSH
  module FS3Combat
    class CombatStancesCmd
      include CommandHandler

      def handle
        template = StancesTemplate.new(FS3Combat.stances)
        client.emit template.render
      end
    end
  end
end