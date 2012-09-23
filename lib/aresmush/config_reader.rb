require 'yaml'

module AresMUSH
  class ConfigReader    
    def initialize(path)
      @path = path
      @config = {}
    end
    
    def read
      server_config = YAML::load( File.open( "#{@path}/server.yaml" ) )
      @config = @config.merge(server_config)
    end
    
    def config
      @config
    end
  end
end