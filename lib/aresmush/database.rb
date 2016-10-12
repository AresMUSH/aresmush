module AresMUSH  
  class Database

    def load_config
      host = Global.read_config("database", "url")
      password = Global.read_config("database", "password")
      Global.logger.info("Database config: #{host}")
      
      begin
        Ohm.redis = Redic.new("redis://:#{password}@#{host}")
                    
      rescue Exception => e
        Global.logger.fatal("Error loading database config.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end       
  end
end