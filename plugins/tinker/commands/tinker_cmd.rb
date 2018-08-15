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
        type = FS3Skills.get_ability_type(cmd.args)
        ability = FS3Skills.find_ability(enactor, cmd.args)
        client.emit "#{type} - #{ability.rating}"
      end



    end
  end
end
