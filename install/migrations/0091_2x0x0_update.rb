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
        config["manage"]["block_types"] = [ "pm" ]
        DatabaseMigrator.write_config_file("manage.yml", config)    
        
        Character.all.each do |c|
          c.page_ignored.each do |block|
            BlockRecord.create(owner: c, blocked: block, block_type: "pm")      
          end
          c.page_ignored.replace([])          
        end
      end
    end
  end    
end