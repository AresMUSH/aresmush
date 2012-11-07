require 'mongo'

def db
  AresMUSH::Database.db
end

module AresMUSH
  class Database
    def initialize(config_reader, root_dir)
      @config_reader = config_reader
    end

    def self.db
      @@db
    end

    def self.players
      @@db[:players]
    end
    
    def connect
      db_config = @config_reader.config['db']
      host = db_config['host']
      port = db_config['port']
      host = db_config['host']
      db_name = db_config['database']      
      logger.info("Connection to database: host=#{host} port=#{port} db=#{db_name}")

      begin
        connection = Mongo::Connection.new(host, port)
        @@db = connection.db(db_name)
        authenticate
      rescue Exception => e
        logger.fatal("Error connecting to database.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end
    
    private
    
    def authenticate
      auth_successful = @@db.authenticate(db_config['username'], db_config['password'])
      raise SystemException("Database authentication failed.") if !auth_successful
    end
  end
end