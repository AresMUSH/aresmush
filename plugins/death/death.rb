$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Death
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("death", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "death"
        case cmd.switch
        when "undo"
          return DeathUndoCmd
        end
      end      
      return nil
    end
  end
end
