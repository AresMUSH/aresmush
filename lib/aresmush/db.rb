require 'sequel'

def db
  AresMUSH::Database.db
end

module AresMUSH
  class Database
    def initialize(config_reader, root_dir)
      @config_reader = config_reader
      @models_dir = File.join(root_dir, "models")
    end

    def self.db
      @@db
    end

    def connect
      db_config = @config_reader.config['db']

      logger.info("Connection to database: adapter=#{db_config['adapter']} host=#{db_config['host']}")

      begin
        @@db = Sequel.connect(
        :adapter => db_config['adapter'], 
        :host => db_config['host'], 
        :database => db_config['database'], 
        :user => db_config['username'], 
        :password => db_config['password'])
      rescue Exception => e
        logger.fatal("Error connecting to database.  Please check your dabase configuration and Sequel installation requirements: #{e}.")      
        raise e
      end
      
      load_models
    end
    
    def load_models
      models = Dir[File.join(@models_dir, "**", "*.rb")]
      models.each do |f| 
         require f
       end
    end
  end
end