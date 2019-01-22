module AresMUSH
  module Custom
    class SetSecretsCmd
      include CommandHandler
# `secrets/set <name>=<secret>` - Set a secret on a character.

      attr_accessor :secrets, :target

        def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target = Character.find_one_by_name(args.arg1)
          self.secrets = trim_arg(args.arg2)
        end

      def check_can_set
         return nil if enactor.has_permission?("view_bgs")
         t('dispatcher.not_allowed')
      end

      def check_errors
        return t('db.object_not_found') if !self.target
      end


      def handle
        client.emit "#{self.target.name}'s current secrets: #{self.target.secrets}"
        self.target.update(secrets: self.secrets)
        client.emit_success "You set #{self.target.name}'s new secrets to #{self.secrets}"
      end

    end
  end
end
