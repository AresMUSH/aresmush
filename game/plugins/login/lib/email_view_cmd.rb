module AresMUSH
  module Login
    class EmailViewCmd
      include AresMUSH::Plugin
      
      attr_accessor :name

      # Validators
      must_be_logged_in
      character_must_exist self.name

      def want_command?(client, cmd)
        cmd.root_is?("email")
      end

      def crack!
        self.name = cmd.args.nil? ? client.name : cmd.args
      end

      # TODO - validate permissions if viewing someone else's email
      
      def handle
        if (char.email.nil?)
          client.emit_ooc(t('login.no_email_is_registered', :name => self.name))
        else
          client.emit_ooc(t('login.email_registered_is', :name => self.name, :email => char.email))
        end
      end
    end
  end
end
