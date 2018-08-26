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
        name_string = "test1 test2 testing1"
        targets = Custom.parse_spell_targets(enactor, name_string)
        client.emit targets




      end



    end
  end
end
