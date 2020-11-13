$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Login
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("login", "shortcuts")
    end
    
    def self.init_plugin
      Login.blacklist = nil
    end
    
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "activity"
        return ActivityCmd
      when "boot"
        return BootCmd
      when "connect"
        if (cmd.args && cmd.args.start_with?("guest"))
          return TourCmd
        else
          return ConnectCmd
        end
      when "create"
        case cmd.switch
        when "reserve"
          return ReserveCmd
        else
          return CreateCmd
        end
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
      when "motd"
        case cmd.switch
        when "set"
          return MotdSetCmd
        else
          return MotdViewCmd
        end
      when "notices"
        case cmd.switch
        when "catchup"
          return NoticesCatchupCmd
        when "motd"
          return MotdViewCmd
        when nil, "unread"
          return NoticesCmd
        end
      when "onconnect"
        case cmd.switch
        when "clear"
          return OnConnectCmd
        when "edit"
          return OnConnectEditCmd
        else
          if (cmd.args)
            return OnConnectCmd
          else
            return OnConnectViewCmd
          end
        end
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
      when "GameStartedEvent"
        return GameStartedEventHandler
      when "CronEvent"
        return CronEventHandler
      when "RoleChangedEvent"
        return RoleChangedEventHandler
      when "ConnectionEstablishedEvent"
        return ConnectionEstablishedEventHandler
      when "CharIdledOutEvent"
        return CharIdledOutEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "checkToken"
        return CheckTokenRequestHandler
      when "login"
        return LoginRequestHandler
      when "loginInfo"
        return LoginInfoRequestHandler
      when "register"
        return RegisterRequestHandler
      when "updateAccountInfo"
        return UpdateAccountInfoRequestHandler
      when "changePassword"
        return ChangePasswordRequestHandler
      when "accountInfo"
        return AccountInfoRequestHandler
      when "loginNotices"
        return LoginNoticesRequestHandler
      when "markNotificationsRead"
        return LoginNoticesMarkReadRequestHandler
      when "markNotificationRead"
        return LoginNoticeMarkReadRequestHandler
      end
      nil
    end
    
    def self.check_config
      validator = LoginConfigValidator.new
      validator.validate
    end
  end
end
