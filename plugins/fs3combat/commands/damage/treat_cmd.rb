module AresMUSH
  module FS3Combat
    class TreatCmd
      include CommandHandler

      attr_accessor :name, :model

      def parse_args
        self.name = titlecase_arg(cmd.args)
        # EM CHANGES
        self.model = Character.named(self.name) || Mount.named(self.name)
        return t('magic.invalid_name') if !self.model
        # /EM CHANGES
      end

      def required_args
        [ self.name ]
      end

      def check_in_combat
        return t('fs3combat.use_combat_treat_instead') if FS3Combat.is_in_combat?(enactor.name)
        return nil
      end

      def handle
        # EM CHANGES
        enactor_room.emit_ooc FS3Combat.treat(self.model, enactor)
        # /EM CHANGES
        # ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
        #   enactor_room.emit_ooc FS3Combat.treat(model, enactor)
        # end
      end
    end
  end
end