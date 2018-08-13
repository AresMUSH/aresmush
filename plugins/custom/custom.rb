$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      #Secrets
      case cmd.root
      when "secrets"
        case cmd.switch
        when "set"
          return SetSecretsCmd
        when "preference"
          return SetSecretPrefCmd
        else
          return SecretsCmd
        end
      end
      case cmd.root
      when "gmsecrets"
        case cmd.switch
        when "set"
          return SetGMSecretsCmd
        else
          return GMSecretsCmd
        end
      end

      return nil
    end
  end
end
