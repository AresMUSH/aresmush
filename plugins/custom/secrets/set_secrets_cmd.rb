module AresMUSH
  module Custom
    class SetSecretsCmd
      include CommandHandler
# `secrets/set <name>=<secret_name>/<secret_summary>` - Set a secret on a character.

      attr_accessor :secret_name, :secret_summary, :target

        def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.target = Character.find_one_by_name(args.arg1)
          self.secret_name = trim_arg(args.arg2)
          self.secret_summary = args.arg3
        end

      def check_can_set
         return nil if enactor.has_permission?("view_bgs")
         t('dispatcher.not_allowed')
      end

      def check_errors
        return t('db.object_not_found') if !self.target
      end


      def handle
        client.emit "#{self.target.name}'s current secrets: %R#{self.target.secret_name}%R#{self.target.secret_summary}"
        self.target.update(secret_name: self.secret_name)
        self.target.update(secret_summary: self.secret_summary)
        client.emit_success "You set #{self.target.name}'s new secrets to: %R#{self.target.secret_name}%R#{self.target.secret_summary}"
      end

    end
  end
end
