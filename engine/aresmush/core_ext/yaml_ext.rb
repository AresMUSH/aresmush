module AresMUSH  
  class YamlExtensions
    def self.yaml_hash(path)      
      contents = File.read(path)
      YAML::load( contents )
    end    
  end
end
