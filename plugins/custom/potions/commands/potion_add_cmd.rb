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
        return t('custom.not_spell') if !Custom.is_spell?(self.potion_name)
        return t('custom.not_potion') if !Custom.is_potion?(self.potion_name)
        return nil
      end

      def handle

        PotionsHas.create(name: potion_name, character: self.target)

        client.emit_success t('custom.added_potion', :potion => potion_name, :target => target.name)

        other_client = Login.find_client(self.target)
        message = t('custom.given_potion', :name => enactor.name, :potion => potion.name)
        Login.emit_if_logged_in self.target,
        Mail.send_mail([target.name], t('custom.given_potion_subj', :potion => potion.name), message, nil)


      end






    end
  end
end
