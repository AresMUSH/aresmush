require "aresmush"

def self.plugin_files(name = "*")
  dir = File.join(File.dirname(__FILE__), "*", "**", "*.rb")
  all_files = Dir[dir]  
  all_files.select { |f| !/_spec[s]*.rb*/.match(f) }
end

plugin_files.each do |f|
  load f
end

RSpec.configure do |c|
  c.include AresMUSH::SpecHelpers
  AresMUSH::TagExtensions.register  
end

module AresMUSH
  module CommandTestHelper
    include MockClient
    
    attr_accessor :client, :char, :cmd, :handler
    
    def init_handler(handler_class, cmd_text)
      mock_client = build_mock_client
      @client = mock_client[:client]
      @char = mock_client[:char]
      
      @cmd = Command.new(cmd_text)
      
      @handler = handler_class.new
      @handler.client = @client
      @handler.cmd = @cmd
    end    
  end
end