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
        char = enactor
        spell = Custom.find_spell_learned(enactor, spell_name)
        level = spell.level
        school = spell.school
        spells_learned =  char.spells_learned.to_a
        if_discard = spells_learned.delete(spell)        

        if spells_learned.any? {|s| s.level > level && s.school == school}
          client.emit "there is a spell with a level  greater than the level of the spell I'm discarding"
          if spells_learned.any? {|s| s.level == level && s.school == school}
            client.emit "there is another spell with the same level as the level of the spell I'm discarding"
            client.emit "true"
          else
            client.emit "false"
          end
        else
          client.emit true
        end



        # time_left = Custom.time_to_next_learn_spell(enactor, spell)
        # days = time_left.to_i / 86400




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
