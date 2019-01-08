module AresMUSH
  module Custom
    class SetSecretPrefCmd
      include CommandHandler
# `secrets/preference <preference>` - Set your secret preference.

      attr_accessor :preference

        def parse_args
          self.preference = cmd.args
        end

      def handle
        if self.preference == "None"
          enactor.update(secretpref: self.preference)
          client.emit_success "You have set your secret preference to #{self.preference}"
        elsif self.preference == "PC-created"
          enactor.update(secretpref: self.preference)
          client.emit_success "You have set your secret preference to #{self.preference}"
        elsif self.preference == "GM-created"
          enactor.update(secretpref: self.preference)
          client.emit_success "You have set your secret preference to #{self.preference}"
        else
          client.emit_failure "That is not a secret preference. Use None, PC-created, or GM-created."
        end
      end

    end
  end
end
