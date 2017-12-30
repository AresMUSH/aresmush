$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Login
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("login", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "activity"
        return ActivityCmd
      when "alias"
        return AliasCmd
      when "boot"
        return BootCmd
      when "create"
        return CreateCmd
      when "email"
        case cmd.switch
        when "set"
          return EmailSetCmd
        when nil
          return EmailViewCmd
        end
      when "keepalive"
        if (cmd.args)
          return KeepaliveSetCmd
        else
          return KeepaliveCmd
        end
      when "last"
        return LastCmd
      when "password"
        case cmd.switch
        when "reset"
          return PasswordResetCmd
        when nil, "set"
          return PasswordSetCmd
        end
      when "quit"
        return QuitCmd
      when "tos"
        case cmd.switch
        when "agree"
          return TosCmd
        when "reset"
          return TosResetCmd
        end
      when "tour"
        return TourCmd
      when "connect"
        return ConnectCmd
      when "watch"
        return WatchCmd
      end
         
      # Special check to allow 'c' to be used for tour or connect when not logged in.
      if (!client.logged_in?)
        if (cmd.args && (cmd.root_is?("c") || cmd.root_is?("co")))
          if (cmd.args.start_with?("guest"))
            return TourCmd
          else
            return ConnectCmd
          end
        end
      end
      nil
    end

    def self.get_event_handler(event_name)      
      case event_name
      when "CharCreatedEvent"
        return CharCreatedEventHandler
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      when "CharDisconnectedEvent"
        return CharDisconnectedEventHandler
      when "ConfigUpdatedEvent", "GameStartedEvent"
        return ConfigUpdatedEventHandler
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "login"
        return LoginRequestHandler
      when "register"
        return RegisterRequestHandler
      end
      nil
    end
  end
end
