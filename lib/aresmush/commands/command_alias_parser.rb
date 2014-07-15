module AresMUSH
  class CommandAliasParser
    def self.substitute_aliases(client, cmd)
      if (cmd.args.nil? && cmd.switch.nil? && !client.room.nil? && client.room.has_exit?(cmd.root))
        cmd.args = cmd.root
        cmd.root = "go"
        return
      end
      
      shortcut_config = Global.config['shortcuts']
      return if shortcut_config.nil?
      
      roots_config = shortcut_config['roots']
      root = cmd.root.downcase
      if (!roots_config.nil? && roots_config.has_key?(root))
        cmd.root = roots_config[root]
      end
      
      full_config = shortcut_config['full']
      separator = cmd.switch.nil? ? "" : "/" 
      root_plus_switch = "#{cmd.root}#{separator}#{cmd.switch}".downcase
      if (!full_config.nil? && full_config.has_key?(root_plus_switch))
        new_cmd = full_config[root_plus_switch]
        cmd.root = new_cmd.first("/")
        cmd.switch = new_cmd.rest("/")
        cmd.switch = cmd.switch.empty? ? nil : cmd.switch
      end
    end
  end
end