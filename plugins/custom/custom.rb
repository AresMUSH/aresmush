$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end

    def self.achievements
      Global.read_config('custom', 'achievements')
    end

    def self.get_cmd_handler(client, cmd, enactor)

      case cmd.root
      when "lastrp"
        return LastRPCmd
      end

      case cmd.root
      when "playerlist"
        return PlayerListCmd
      end



      #Plots
      case cmd.root
      when "plot"
        case cmd.switch
        when "propose"
          return PlotProposeCmd
        end
      end

      #PlotPrefs
      case cmd.root
      when "plotprefs"
        case cmd.switch
        when "set"
          return PlotPrefsSetCmd
        when nil
          return PlotPrefsViewCmd
        end
      end

      #Secrets
      case cmd.root
      when "secrets"
        case cmd.switch
        when "set"
          return SetSecretsCmd
        when "preference"
          return SetSecretPrefCmd
        when "setplot"
          return SetSecretsPlotCmd
        when nil
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

      #Schools
      case cmd.root
      when "school"
        case cmd.switch
        when "set"
          return SetSchoolsCmd
        else
          return SchoolsCmd
        end
      end

      #Luck request
      case cmd.root
      when "luck"
        case cmd.switch
        when "request"
          return LuckRequestCmd
        end
      end

      return nil
    end
  end
end
