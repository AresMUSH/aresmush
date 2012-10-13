require 'yaml'

module AresMUSH
  class ConfigReader    
    def initialize(path)
      @path = path
      clear_config
    end

    attr_accessor :txt, :config

    def clear_config
      @config = {}
      @txt = {}
    end
    
    def read
      clear_config
      Dir.foreach("#{@path}/config") do |f| 
        file_path = "#{@path}/config/#{f}"
        next if (File.directory?(file_path))
        file_config = YAML::load( File.open( file_path ) )
        @config = @config.merge(file_config)
      end

      Dir.foreach("#{@path}/txt") do |f| 
        file_path = "#{@path}/txt/#{f}"
        next if (File.directory?(file_path))
        file_txt = File.read( file_path ) 
        @txt[File.basename(f, ".*")] = file_txt
      end      
    end
  end
end