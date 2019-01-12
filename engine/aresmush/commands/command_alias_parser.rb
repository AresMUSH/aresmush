module AresMUSH
  class CommandAliasParser
    def self.substitute_aliases(enactor, cmd, shortcut_config)
      if (!cmd.args && !cmd.switch && enactor && enactor.room && enactor.room.has_exit?(cmd.root))
        cmd.args = cmd.root
        cmd.root = "go"
        return
      end      
      
      roots_config = shortcut_config.select { |s| !s.include?('/')}
      if (roots_config)
        root = cmd.root.downcase
        if roots_config.has_key?(root)
          update_cmd(cmd, root, roots_config[root])
        end
      end
            
      full_config = shortcut_config.select { |s| s.include?('/')}
      if (full_config)
        full_config.each do |find_str, replace_str|          
          if compare_root_and_switch(cmd, find_str)
            update_cmd(cmd, find_str, replace_str)
          end
        end
      end

      if (enactor)
        enactor.shortcuts.each do |find_str, replace_str|
          if compare_root_and_switch(cmd, find_str)
            update_cmd(cmd, find_str, replace_str)
          end
        end
      end
    end
    
    def self.compare_root_and_switch(cmd, compare_str)
      if (cmd.switch)
        root_and_switch = "#{cmd.root}/#{cmd.switch}"
      else
        root_and_switch = "#{cmd.root}"
      end
      
      if (root_and_switch == "#{compare_str}")
        return true
      else
        return false
      end
      
    end
    
    def self.update_cmd(cmd, find_str, replace_str)
      cmd.raw.sub!(/^[\/\+\=\@\&]?#{find_str}/i, replace_str)
      cmd.crack!
    end
  end
end