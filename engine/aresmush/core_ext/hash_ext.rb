class Hash
  
  def merge_recursively(other_hash)
    self.merge(other_hash) {|key, a_item, b_item| a_item.merge_recursively(b_item) }
  end
  
  def merge_recursively!(other_hash)
    self.replace(self.merge_recursively(other_hash))
  end
  
  def merge_yaml(file_path)
    begin 
      file_data = AresMUSH::YamlExtensions.yaml_hash(file_path)
      self.merge_recursively(file_data)
    rescue Exception => ex
      # Turn mysterious YAML errors into something a little more useful.
      raise "Error reading YAML from #{file_path}.  See the Troubleshooting YAML tutorial https://aresmush.com/tutorials/code/yaml.html for help: #{ex}"
    end
  end
  
  def merge_yaml!(file_path)
    begin 
      file_data = AresMUSH::YamlExtensions.yaml_hash(file_path)
      self.merge_recursively!(file_data)
    rescue Exception => ex
      # Turn mysterious YAML errors into something a little more useful.
      raise "Error reading YAML from #{file_path}.  See the Troubleshooting YAML tutorial at https://aresmush.com/tutorials for help: #{ex}"
    end
  end
  
  def deep_match(regex)
    self.select do |k, v| 
      if v.is_a?(Hash)
        next(true) if regex.match(v.to_s)
        next(false)
      end
      next(true) if regex.match(k)
      next(true) if regex.match(v)
      next(false)
    end
  end
  
  def has_insensitive_key?(key)
    return false if !key
    !get_insensitive_key(key).nil?
  end
  
  def get_insensitive_key(key)
    self.keys.select { |k| k.downcase == key.downcase }.first
  end
  
  def get_insensitive_value(key)
    return false if !key
    self[get_insensitive_key(key)]
  end
end