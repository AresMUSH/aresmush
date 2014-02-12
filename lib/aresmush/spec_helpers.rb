# figure out where we are being loaded from
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
  rescue => e
    puts <<-MSG
    ===================================================
    It looks like spec_helper.rb has been loaded
    multiple times. Normalize the require to:

    require "spec/spec_helper"

    Things like File.join and File.expand_path will
    cause it to be loaded multiple times.

    Loaded this time from:

    #{e.backtrace.join("\n    ")}
    ===================================================
    MSG
  end
end

module AresMUSH
  
  module SpecHelpers
    def self.stub_translate_for_testing
      # Simple helper to stub out translations.  Only works well if you 
      # have a simple string because it doesn't do anything with the args
      AresMUSH::Locale.stub(:translate) do |str|
        "#{str}"
      end
    end    
    
    def self.connect_to_test_db
      config = YAML::load(File.open("game/config/database.yml"))
      host = config['testdb']['host']
      port = config['testdb']['port']
      username = config['testdb']['username']
      password = config['testdb']['password']
      db_name = 'arestest'
    
      connection = Mongo::Connection.new(host, port)
      db = connection.db(db_name)
      auth_successful = db.authenticate(username, password)
      raise StandardError("Database authentication failed.") if !auth_successful    
      MongoMapper.connection = connection
      MongoMapper.database = db_name
      db
    end
  end  
  
  module MockClient
    def build_mock_client
      client = double
      char = double
      client.stub(:char) { char }
      {
        :client => client,
        :char => char
      }
    end
  end
    
end