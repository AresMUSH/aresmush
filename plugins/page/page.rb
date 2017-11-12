$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Page
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("page", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "page"
        case cmd.switch
        when "autospace"
          return PageAutospaceCmd
        when "color"
          return PageColorCmd
        when "dnd"
          return PageDoNotDisturbCmd
        when "ignore"
          return PageIgnoreCmd
        when nil
          # It's a common mistake to type 'p' when you meant '+p' for a channel, but
          # not vice-versa.  So ignore any command that has a prefix. 
          if (!cmd.prefix)
            return PageCmd
          end
        end
      end 
          
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end
