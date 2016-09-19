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
      Global.read_config("sheet", "shortcuts")
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
      [ "config_sheet.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       false
    end

    def self.handle_event(event)
    end
  end
end