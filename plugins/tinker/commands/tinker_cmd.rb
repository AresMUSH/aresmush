module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end




      def handle

        if (cmd.args =~ /\//)
          args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          self.spell = titlecase_arg(args.arg2)
          target_name = titlecase_arg(args.arg3)
          self.caster = combat.find_combatant(caster_name)
          self.target = combat.find_combatant(target_name)
        else
          args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>.+)?/)
          self.caster = enactor.combatant
          self.spell = titlecase_arg(args.arg1)
          target_name = titlecase_arg(args.arg2)
          self.target = FS3Combat.find_named_thing(target_name, self.caster)
        end
        client.emit self.caster.name
        client.emit self.spell
        client.emit self.target.name

=======
      def handle
        enactor.combatant.update(has_cast: false)
      end

      def handle
        school = cmd.args
        successes = Custom.roll_combat_spell(enactor, enactor.combatant, cmd.args)
        client.emit successes
        # client.emit die_result
        client.emit school

      end



    end
  end
end
