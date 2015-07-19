module AresMUSH  
  class Database

    def load_config
      db_config = Global.read_config("database", "production")
      host = db_config['sessions']['default']['hosts']
      db_name = db_config['sessions']['default']['database']
      Global.logger.info("Database config: #{host} #{db_name}")
      
      # Don't be spammy about underlying moped database driver errors.
      Moped.logger.level = Logger::ERROR
      
      begin
        Mongoid.load_configuration(db_config)
        #Mongoid.load!("/Users/lynn/Code/aresmush/game/config/mongoid.yml", :foo)
        #puts Mongoid.models
        #puts Character.all.count
        #puts Mongoid.sessions.inspect
        #exit
      rescue Exception => e
        Global.logger.fatal("Error loading database config.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end       
  end
end