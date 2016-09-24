$:.unshift File.dirname(__FILE__)
load "lib/char_backup_command.rb"
load "lib/sheet_cmd.rb"
load "templates/sheet_page1_template.rb"
load "templates/templates.rb"

module AresMUSH
  module FS3Sheet
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("fs3sheet", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/backup.md", "help/sheet.md" ]
    end
 
    def self.config_files
      [ "config_fs3sheet.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
       case cmd.root
       when "sheet"
         return SheetCmd
       when "backup"
         return CharBackupCmd
       end
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end