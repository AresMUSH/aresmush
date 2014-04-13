module AresMUSH
  module Login
    class CreateCmd
      include Plugin
      include PluginWithoutSwitches
      
      attr_accessor :charname, :password
      
      def want_command?(client, cmd)
        cmd.root_is?("create")
      end

      def crack!
        cmd.crack!(/(?<name>[\S]+) (?<password>.+)/)
        self.charname = trim_input(cmd.args.name)
        self.password = cmd.args.password
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end      
      
      def check_name
        return t('dispatcher.invalid_syntax', :command => 'create') if charname.nil?
        return Character.check_name(charname)
      end
      
      def check_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if password.nil?
        return Character.check_password(password)
      end
      
      def handle        
        char = Character.new
        char.name = charname
        char.change_password(password)
        char.save!
        
        client.emit_success(t('login.created_and_logged_in', :name => charname))
        client.char = char
        Global.dispatcher.on_event(:char_created, :client => client)
        Global.dispatcher.on_event(:char_connected, :client => client)        
      end
      
      def log_command
        # Don't log full command for privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end      
    end
  end
end
