module AresMUSH
  module Magic
    class PotionRemoveCmd
      include CommandHandler
# potion/add <name>=<potion> - Give someone a potion.

      attr_accessor :target, :potion_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.named(args.arg1)
        self.potion_name = titlecase_arg(args.arg2)
        self.potion = Magic.find_potion_has(self.target, self.potion_name)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_permission?("manage_magic")
      end

      def check_errors
        return t('magic.invalid_name') if !self.target
        return t('magic.not_spell') if !Magic.is_spell?(self.potion_name)
        return t('magic.not_potion') if !Magic.is_potion?(self.potion_name)
        return t('magic.dont_have_potion') if !potion
        return nil
      end

      def handle
        potion.delete
        client.emit_success t('magic.removed_potion', :potion => potion_name, :target => target.name)

        other_client = Login.find_client(self.target)
        message = t('magic.potion_has_been_removed', :name => enactor.name, :potion_name => potion_name)
        Login.emit_if_logged_in(self.target, message)
        Login.notify(self.target, :potion, message, nil)
      end

    end
  end
end
