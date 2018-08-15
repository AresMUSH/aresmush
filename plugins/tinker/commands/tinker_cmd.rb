module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials, :caster, :spell, :target
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end




      def handle
        spell = "Gust"
        emit = Global.read_config("spells", spell, "level")
        client.emit emit
      end



    end
  end
end
