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
    
    def using_test_db(&block)
      client_monitor = double
      Global.stub(:client_monitor) { client_monitor }
      client_monitor.stub(:clients) { [] }
      SpecHelpers.connect_to_test_db
      yield block
      SpecHelpers.erase_test_db
    end
      
    # Use with the using_test_db helper whenever possible
    def self.connect_to_test_db
      filename = File.join(AresMUSH.game_path, "config/database.yml")
      config = YAML::load(File.open(filename))
      db_config = config['database']['test']
      host = db_config['host']
      port = db_config['port']
      db_name = db_config['database']  
      username = db_config['username']  
      password = db_config['password']      
    
      mongoid = Mongoid.load_configuration(db_config)
        #db = mongoid.database
      
      #auth_successful = db.authenticate(username, password)
     # raise StandardError("Database authentication failed.") if !auth_successful    
    #  db
    end
    
    # Use with the using_test_db helper whenever possible
    def self.erase_test_db
      AresMUSH::Character.delete_all
      AresMUSH::Game.delete_all  
      AresMUSH::Room.delete_all
      AresMUSH::Exit.delete_all
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