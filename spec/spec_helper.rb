require 'rspec'

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
      stub_client_reload
      SpecHelpers.connect_to_test_db
      SpecHelpers.erase_test_db
      yield block
      SpecHelpers.erase_test_db
    end
    
    def stub_client_reload
      client_monitor = double
      Global.stub(:client_monitor) { client_monitor }
      client_monitor.stub(:reload_clients) { }
    end
      
    # Use with the using_test_db helper whenever possible
    def self.connect_to_test_db
      filename = File.join(AresMUSH.game_path, "config/database.yml")
      config = YAML::load(File.open(filename))
      db_config = config['database']['test']
          
      if (db_config.nil? || db_config['clients']['default']['database'].nil?)
        raise "Test DB not defined."
      end
      
      mongoid = Mongoid.load_configuration(db_config)
      
      Mongoid.logger.level = Logger::WARN
      Mongo::Logger.logger.level = Logger::WARN
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
      char.stub(:client) { client }
      client.stub(:char) { char }
      {
        :client => client,
        :char => char
      }
    end
  end

  module GlobalTestHelper
    attr_accessor :config_reader, :client_monitor, :plugin_manager, :dispatcher, :locale
    
    def stub_global_objects
      @config_reader = double
      @client_monitor = double
      @plugin_manager = double
      @dispatcher = double
      @locale = double
      
      Global.stub(:config_reader) { @config_reader }
      Global.stub(:client_monitor) { @client_monitor }
      Global.stub(:plugin_manager) { @plugin_manager }
      Global.stub(:dispatcher) { @dispatcher }
      Global.stub(:locale) { @locale }
    end
  end
  
  module GameTestHelper
    attr_accessor :game
    
    def stub_game_master
      @game = double
      Game.stub(:master) { @game }
    end
  end
    
end


RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.include AresMUSH::SpecHelpers
end