module AresMUSH
  module Custom
    class SetSecretsCmd
      include CommandHandler
# `secrets/setplot <name>=<secret_plot>/` - Set a secret's plot on a character.

      attr_accessor :secret_plot :target

        def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target = Character.find_one_by_name(args.arg1)
          self.secret_plot = trim_arg(args.arg2)
        end

      def check_can_set
         return nil if enactor.has_permission?("view_bgs")
         t('dispatcher.not_allowed')
      end

      def check_errors
        return t('db.object_not_found') if !self.target
      end


      def handle
        self.target.update(secret_plot: self.secret_plot)client.emit_success "You set #{self.target.name}'s secret plot to #{self.target.secret_plot}"
      end

    end
  end
end
