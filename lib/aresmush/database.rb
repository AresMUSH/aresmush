module AresMUSH  
  class Database

    def load_config
      db_config = Global.read_config("database", "production")
      host = db_config['clients']['default']['hosts']
      db_name = db_config['clients']['default']['database']
      Global.logger.info("Database config: #{host} #{db_name}")
      
      begin
        Mongoid.load_configuration(db_config)
        
        Mongoid.logger.level = Logger::WARN
        Mongo::Logger.logger.level = Logger::WARN
                
      rescue Exception => e
        Global.logger.fatal("Error loading database config.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end       
  end
end