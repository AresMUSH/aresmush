module AresMUSH  
  class YamlExtensions
    def self.yaml_hash(path)      
      YAML::load( File.open( path ) )
    end    
  end
end
