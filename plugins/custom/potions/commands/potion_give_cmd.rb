module AresMUSH
  module Custom
    class GivePotionCmd
      include CommandHandler
# potion/give <name>=<number> - Give a potion to someone.
      attr_accessor :char, :potion, :target, :potion_name, :other_client

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.char = titlecase_arg(args.arg1)
        self.potion_name = titlecase_arg(args.arg2)
        self.potion = Custom.find_potion_has(enactor, self.potion_name)
        self.target = Character.find_one_by_name(self.char)

      end

      def check_errors
        return t('custom.dont_have_potion') if !Custom.find_potion_has(enactor, self.potion_name)
        return t('custom.not_character') if !self.target
        return nil
      end

      def handle
        self.other_client = Login.find_client(target)
        PotionsHas.create(name: self.potion.name, character: self.target)
        self.potion.delete

        client.emit_success t('custom.give_potion', :target => target.name, :potion => potion.name)        
        message = t('custom.given_potion', :name => enactor.name, :potion => potion.name)
        Login.emit_if_logged_in self.target, message
        Mail.send_mail([target.name], t('custom.given_potion_subj', :potion => potion.name), message, nil)



      end

    end
  end
end
