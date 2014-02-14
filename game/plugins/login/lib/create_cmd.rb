module AresMUSH
  module Login
    class Create
      include AresMUSH::Plugin
      
      def want_command?(cmd)
        cmd.root_is?("create")
      end

      def crack!
        cmd.crack!(/(?<name>\S+) (?<password>.+)/)
      end
      
      def validate
        return t('dispatcher.already_logged_in') if cmd.logged_in?
        return t('login.invalid_create_syntax') if (args.name.nil? || args.password.nil?)
        
        check_name = Login.validate_char_name(args.name)
        return check_name if !check_name.nil?
        
        check_password = Login.validate_char_password(args.password)
        return check_password if !check_password.nil?
        
        return nil
      end
      
      def handle        
        name = args.name
        password = args.password
                
        char = Character.new
        char.name = name
        char.change_password(password)
        char.save!
        
        @client.emit_success(t('login.created_and_logged_in', :name => name))
        @client.char = char
        Global.dispatcher.on_event(:char_created, :client => @client)
        Global.dispatcher.on_event(:char_connected, :client => @client)        
      end
      
      def log_command
        # Don't log full command for privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end      
    end
  end
end
