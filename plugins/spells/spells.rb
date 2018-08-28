$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Spells

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("spells", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      #Spells
      case cmd.root
      when "spell"
        case cmd.switch
        when "request"
          return SpellRequestCmd
        when "mod"
          return SpellModCmd
        when "modis"
          return SpellModIsCmd
        when "cast"
          if cmd.args.include?("=")
            return SpellCastWithTargetCmd
            client.emit "With target."
          else
            return SpellCastCmd
          end
        end
      end
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
