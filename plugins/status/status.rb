$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Status
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("status", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "duty"
        return DutyCmd
      when "afk"
        return GoAfkCmd
      when "npc"
        return NpcCmd
      when "offstage"
        return GoOffstageCmd
      when "onstage"
        return GoOnstageCmd
      when "ooc"
        if (!cmd.args)
          return GoOffstageCmd
        end
      when "playerbit"
        return PlayerBitCmd
      end      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CharDisconnectedEvent"
        return CharDisconnectedEventHandler
      when "CronEvent"
        return AfkCronHandler
      end
      nil
    end
    
    def self.check_config
      validator = StatusConfigValidator.new
      validator.validate
    end
  end
end
