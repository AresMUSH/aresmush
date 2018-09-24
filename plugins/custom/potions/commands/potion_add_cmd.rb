module AresMUSH
  module Custom
    class PotionAddCmd
      include CommandHandler
# potion/add <name>=<potion> - Give someone a potion.

      attr_accessor :target, :potion_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.potion_name = titlecase_arg(args.arg2)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !FS3Skills.can_manage_abilities?(enactor)
      end

      def check_errors
        return t('custom.invalid_name') if !self.target
        return t('custom.not_spell') if !Custom.is_spell?(cmd.args)
        return t('custom.not_potion') if !Custom.is_potion?(cmd.args)
        return nil
      end

      def handle

        PotionsHas.create(name: potion.name, character: self.target)
        client.emit_success t('custom.added_potion', :potion_name => potion_name, :target => target.name)
        other_client = Login.find_client(self.target)
        other_client.emit_success t('custom.potion_has_been_added', :name => enactor.name, :potion_name => potion_name)

      end






    end
  end
end
