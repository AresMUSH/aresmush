module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      attr_accessor :spells_learned





      def handle
        spell_name = cmd.args
        spell = Custom.find_spell_learned(enactor, spell_name)
        spell_list = enactor.spells_learned.to_a
        time_since = Time.now - spell.last_learned

        # time_left = Custom.time_to_next_learn_spell(enactor, spell)
        # days = time_left.to_i / 86400
        client.emit time_since
        


        # if time_left.to_i > 0
        #   #time left = days / seconds
        #   days = time_left.to_i / 86400
        #   client.emit_failure t('custom.cant_learn_yet', :days => days.ceil)
        # else
        #   client.emit "Okay"
        # end




      end











    end
  end
end
