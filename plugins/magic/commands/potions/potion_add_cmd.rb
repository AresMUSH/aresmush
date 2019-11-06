module AresMUSH
  module Magic
    class PotionAddCmd
      include CommandHandler
# potion/add <name>=<potion> - Give someone a potion.

      attr_accessor :target, :potion_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.named(args.arg1)
        self.potion_name = titlecase_arg(args.arg2)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_permission?("view_bgs")
      end

      def check_errors
        return t('magic.invalid_name') if !self.target
        return t('magic.not_spell') if !Magic.is_spell?(self.potion_name)
        return t('magic.not_potion') if !Magic.is_potion?(self.potion_name)
        return nil
      end

      def handle

        PotionsHas.create(name: potion_name, character: self.target)

        client.emit_success t('magic.added_potion', :potion => potion_name, :target => target.name)

        other_client = Login.find_client(self.target)
        message = t('magic.given_potion', :name => enactor.name, :potion => potion_name)
        Login.emit_if_logged_in(self.target, message)
        Login.notify(self.target, :potion, message, nil)
        # Mail.send_mail([target.name], t('magic.given_potion_subj', :potion => potion_name), message, nil)


      end






    end
  end
end
