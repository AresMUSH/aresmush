module AresMUSH  

  module Migrations
    class Migration2x0x0Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Replace logging config."
        config = {
          "logger" => {
            "max_size_bytes" => 125000,
            "max_files" => 10
          }
        }
        DatabaseMigrator.write_config_file("logger.yml", config)    
        
        Global.logger.debug "Updating blocks"
        config = DatabaseMigrator.read_config_file("manage.yml")
        config["manage"]["shortcuts"] = config["manage"]["shortcuts"] || {}
        config["manage"]["shortcuts"]["blocks"] = "block"
        config["manage"]["block_types"] = [ "pm", "channel" ]
        DatabaseMigrator.write_config_file("manage.yml", config)    
        
        Character.all.each do |c|
          c.page_ignored.each do |block|
            BlockRecord.create(owner: c, blocked: block, block_type: "pm")      
          end
          c.page_ignored.replace([])          
        end
        
        Global.logger.debug "Adding discord name overrides"
        config = DatabaseMigrator.read_config_file("channels.yml")
        if (!config["channels"]["discord_name_overries"])
          config["channels"]["discord_name_subs"] = {
            "wumpus" => "wumpu5",
            "nelly" => "nell4"
          }
        end
        DatabaseMigrator.write_config_file("channels.yml", config)    
        
        Global.logger.debug "Adding turnstile"
        config = DatabaseMigrator.read_config_file("secrets.yml")
        if (!config["secrets"]["turnstile"])
          config["secrets"]["turnstile"] = {
            "site_key" => "",
            "secret" => ""
          }
        end
        DatabaseMigrator.write_config_file("secrets.yml", config)    
        
        
        Global.logger.debug "Adding new theme colorss"        
        src = File.join(AresMUSH.game_path, "styles", "colors.scss")
        config = File.readlines(src)
        if (!config.any? { |c| c =~ /box-words/ })
          config << "$box-background-color: $background-color;"
          config << "$box-words-color: $text-color;"
          config << "$secondary-words-color: $text-color;"         
        end
        File.open(src, 'w') do |file|
          file.puts config
        end
        
      end
    end
  end    
end