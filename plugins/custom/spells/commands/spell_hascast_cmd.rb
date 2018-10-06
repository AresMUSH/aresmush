module AresMUSH
  module Custom
    class SpellHascastCmd
    #spell/hascast <name>=<true/false>
      include CommandHandler
      attr_accessor :caster_combat, :hascast

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        if (cmd.args =~ /\//)
          #Forcing NPC or PC to cast
          args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          self.hascast = titlecase_arg(args.arg2)

          #Returns combatant
          if enactor.combat
            self.caster_combat = combat.find_combatant(caster_name)
          else
            client.emit_failure t('FS3.not_in_combat')
          end

        else
          #Enactor casts
          args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>.+)?/)
          self.hascast = titlecase_arg(args.arg1)

          #Returns combatant
          if enactor.combat
            combat = enactor.combat
            self.caster_combat = enactor.combatant
          else
            client.emit_failure t('FS3.not_in_combat')
          end

        end
      end

      def handle
        if self.hascast == "true"
          hascast = true
        elsif self.hascast == "false"
          hascast = false
        end
        self.caster_combat.update(has_cast: hascast)
        client.emit_success "#{caster_combat.name}'s has_cast has been set to #{caster_combat.has_cast}."
      end
    end
  end
end
