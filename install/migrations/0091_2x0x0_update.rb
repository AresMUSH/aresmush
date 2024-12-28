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
      end
    end
  end    
end