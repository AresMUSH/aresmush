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
    
    def self.setup_mock_client(client, char)
      client.stub(:char) { char }
      char.stub(:client) { client }
    end
  end  
  
  module GlobalTestHelper
    attr_accessor :config_reader, :client_monitor, :dispatcher, :plugin_manager, :dispatcher, :locale, :help_reader, :notifier
    
    def stub_global_objects
      @config_reader = double
      @client_monitor = double
      @plugin_manager = double
      @dispatcher = double
      @locale = double
      @help_reader = double
      @notifier = double
      
      Global.stub(:notifier) { @notifier }
      Global.stub(:config_reader) { @config_reader }
      Global.stub(:client_monitor) { @client_monitor }
      Global.stub(:dispatcher) { @dispatcher }
      Global.stub(:plugin_manager) { @plugin_manager }
      Global.stub(:locale) { @locale }
      Global.stub(:help_reader) { @help_reader }
    end
  end  
end


RSpec.configure do |c|
  # No longer needed in rspec 3
  #c.treat_symbols_as_metadata_keys_with_true_values = true
  c.include AresMUSH::SpecHelpers
end