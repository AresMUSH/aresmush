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
        
    def stub_translate_for_testing
      # Simple helper to stub out translations.  Only works well if you 
      # have a simple string because it doesn't do anything with the args
      allow(AresMUSH::Locale).to receive(:translate) do |str|
        "#{str}"
      end
    end    
    
    def setup_mock_client(client, char)
      allow(client).to receive(:char) { char }
      allow(char).to receive(:client) { client }
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
      
      allow(Global).to receive(:notifier) { @notifier }
      allow(Global).to receive(:config_reader) { @config_reader }
      allow(Global).to receive(:client_monitor) { @client_monitor }
      allow(Global).to receive(:dispatcher) { @dispatcher }
      allow(Global).to receive(:plugin_manager) { @plugin_manager }
      allow(Global).to receive(:locale) { @locale }
      allow(Global).to receive(:help_reader) { @help_reader }
    end
  end  
end


RSpec.configure do |c|
  c.include AresMUSH::SpecHelpers
  $:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])
  $:.unshift File.join(File.dirname(__FILE__), *%w[.. plugins])
end
