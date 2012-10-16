module AresMUSH  
  class YamlExtensions
    # Reads yaml from all the files in a directory and sub-directories
    def self.one_yaml_to_rule_them_all(path)
      one_yaml = {}
      Dir.foreach("#{path}") do |f| 
        file_path = "#{path}/#{f}"
        next if (File.directory?(file_path))
        next if (!is_yaml_file(f))
        file_data = YAML::load( File.open( file_path ) )
        
        one_yaml = merge_recursively(one_yaml, file_data)
      end
      one_yaml
    end

    def self.merge_recursively(a, b)
      a.merge(b) {|key, a_item, b_item| merge_recursively(a_item, b_item) }
    end
    
    def self.is_yaml_file(filepath)
      (File.extname(filepath) == ".yml") || (File.extname(filepath) == ".yaml")
    end
  end
end
