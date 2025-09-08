$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Txt
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("txt", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
        case cmd.root
        when "txt"
          case cmd.switch
          when "color"
            return TxtColorCmd
          when "newscene"
            return TxtNewSceneCmd
          when "reply"
            return TxtReplyCmd
          when nil
            return TxtSendCmd
          end
        end
      return nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "addTxt"
        return AddTxtRequestHandler
      end
      nil
    end
  end
end