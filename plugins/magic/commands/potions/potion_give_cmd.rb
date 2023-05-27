module AresMUSH
  module Magic
    class PotionGiveCmd
      include CommandHandler
# potion/give <name>=<number> - Give a potion to someone.
      attr_accessor :char, :potion, :target, :potion_name, :other_client

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.char = titlecase_arg(args.arg1)
        self.potion_name = titlecase_arg(args.arg2)
        self.potion = Magic.find_potion_has(enactor, self.potion_name)
        self.target = Character.find_one_by_name(self.char)

      end

      def check_errors
        return t('magic.not_potion') if !Magic.is_potion?(self.potion_name)
        return t('magic.invalid_name') if !self.target
        return t('magic.dont_have_potion') if !Magic.find_potion_has(enactor, self.potion_name)
        return nil
      end

      def handle
        self.other_client = Login.find_client(target)
        PotionsHas.create(name: self.potion.name, character: self.target)
        self.potion.delete

        client.emit_success t('magic.give_potion', :target => target.name, :potion => potion.name)
        message = t('magic.given_potion', :name => enactor.name, :potion => potion.name)
        Login.emit_if_logged_in self.target, message
        Login.notify(self.target, :potion, message, nil)

      end

    end
  end
end
