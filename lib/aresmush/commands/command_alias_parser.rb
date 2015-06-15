module AresMUSH
  class CommandAliasParser
    def self.substitute_aliases(client, cmd)
      if (cmd.args.nil? && cmd.switch.nil? && !client.room.nil? && client.room.has_exit?(cmd.root))
        cmd.args = cmd.root
        cmd.root = "go"
        return
      end
      
      shortcut_config = Global.read_config("shortcuts")
      return if shortcut_config.nil?
      
      roots_config = shortcut_config['roots']
      if (roots_config)
        root = cmd.root.downcase
        if roots_config.has_key?(root)
          update_cmd(cmd, root, roots_config[root])
        end
      end
      
      full_config = shortcut_config['full']
      if (full_config)
        full_config.each do |find_str, replace_str|
          if (cmd.raw.start_with?("#{cmd.prefix}#{find_str}"))
            update_cmd(cmd, find_str, replace_str)
          end
        end
      end
    end
    
    def self.update_cmd(cmd, find_str, replace_str)
      cmd.raw.sub!(/^[\/\+\=\@\&]?#{find_str}/i, replace_str)
      cmd.crack!
    end
  end
end