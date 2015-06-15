module AresMUSH  
  class Database

    def connect
      db_config = Global.read_config("database", "production")
      host = db_config['sessions']['default']['hosts']
      db_name = db_config['sessions']['default']['database']
      Global.logger.info("Connection to database: #{host} #{db_name}")
      begin
        Mongoid.load_configuration(db_config)
      rescue Exception => e
        Global.logger.fatal("Error connecting to database.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end       
  end
end