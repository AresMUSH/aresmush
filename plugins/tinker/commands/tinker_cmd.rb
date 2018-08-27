module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end





      def handle
        name_string = cmd.args
        combat = enactor.combat
        targets = Custom.parse_spell_targets(name_string, combat)
        targets.each do |t|
          client.emit t
        end
      end



    end
  end
end
