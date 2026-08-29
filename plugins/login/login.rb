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
      when "ban"
        case cmd.switch
        when "list"
          return BanListCmd
        when "add"
          return BanAddCmd
        when "remove"
          return BanRemoveCmd
        when nil
          return BanCmd
        end
      when "boot"
        return BootCmd
      when "connect"
        if Login.is_guest_connect?(client, cmd)
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
          return TosAgreeCmd
        when "reset"
          return TosResetCmd
        else
          return TosCmd
        end
      when "tour"
        return TourCmd
      when "watch"
        return WatchCmd
      end
         
      # Special check to allow shortcuts to be used for tour or 
      # connect when not logged in, while allowing those shortcuts
      # for other things (like channels) when logged in
      if Login.is_connect_shortcut?(client, cmd)
        if Login.is_guest_connect?(client, cmd)
          return TourCmd
        else
          return ConnectCmd
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
      when "tour"
        return TourRequestHandler        
      when "updateAccountInfo"
        return UpdateAccountInfoRequestHandler
      when "changePassword"
        return ChangePasswordRequestHandler
      when "resetPassword"
        return ResetPasswordRequestHandler
      when "accountInfo"
        return AccountInfoRequestHandler
      when "loginNotices"
        return LoginNoticesRequestHandler
      when "markNotificationsRead"
        return LoginNoticesMarkReadRequestHandler
      when "markNotificationRead"
        return LoginNoticeMarkReadRequestHandler
      when "banList"
        return BanListRequestHandler
      when "banAdd"
        return BanAddRequestHandler
      when "banRemove"
        return BanRemoveRequestHandler
      when "banPlayer"
        return BanPlayerRequestHandler
      when "bootPlayer"
        return BootPlayerRequestHandler
      when "saveMotd"
        return SaveMotdRequestHandler
      when "editMotd"
        return EditMotdRequestHandler
      end
      nil
    end
    
    def self.check_config
      validator = LoginConfigValidator.new
      validator.validate
    end    
  end
end
