module AresMUSH  
  class Database

    def self.db
      @@db
    end
    
    def connect
      db_config = Global.config['database']
      host = db_config['host']
      port = db_config['port']
      host = db_config['host']
      db_name = db_config['database']      
      Global.logger.info("Connection to database: host=#{host} port=#{port} db=#{db_name}")

      begin
        connection = Mongo::Connection.new(host, port)
        @@db = connection.db(db_name)
        authenticate(db_config['username'], db_config['password'])
        
        MongoMapper.connection = connection
        MongoMapper.database = db_name
        MongoMapper::Plugins::IdentityMap.enabled = true
        
      rescue Exception => e
        Global.logger.fatal("Error connecting to database.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end       
        
    private
    
    def authenticate(username, password)
      auth_successful = @@db.authenticate(username, password)
      raise StandardError("Database authentication failed.") if !auth_successful
    end
  end
end

# Monkey Patch to solve issue https://github.com/jnunemaker/mongomapper/issues/507
module MongoMapper
  module Plugins
    module Querying
      private
        def save_to_collection(options={})
          @_new = false
          collection.save(to_mongo, :w => options[:safe] ? 1 : 0)
        end
    end
  end
end