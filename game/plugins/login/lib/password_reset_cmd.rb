module AresMUSH
  module Login
    class PasswordResetCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name
      attr_accessor :new_password

      def initialize
        self.required_args = ['name', 'new_password']
        self.help_topic = 'password'
        super
      end

      def want_command?(client, cmd)
        cmd.root_is?("password") && cmd.switch_is?("reset")
      end

      def crack!
        cmd.crack!(/(?<name>[^\=]+)\=(?<password>.+)/)
        self.name = trim_input(cmd.args.name)
        self.new_password = cmd.args.password
      end
      
      def check_new_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if self.new_password.nil?
        return Login.check_char_password(self.new_password)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |char|
          
          if !Login.can_reset_password?(client.char)
            client.emit_failure t('dispatcher.not_allowed') 
            return
          end
          
          char.change_password(self.new_password)
          char.save!
          client.emit_success t('login.password_reset', :name => self.name)
        end
      end
      
      def log_command
        # Don't log full command for password privacy
        name = cmd.args.nil? ? "" : cmd.args.first("=")
        Global.logger.debug("#{self.class.name} #{client} #{name}")
      end
    end
  end
end
