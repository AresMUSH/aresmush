class Hash
  
  def merge_recursively(b)
    self.merge(b) {|key, a_item, b_item| a_item.merge_recursively(b_item) }
  end
  
  def merge_yaml(file_path)
    file_data = AresMUSH::YamlExtensions.yaml_hash(file_path)
    self.merge_recursively(file_data)
  end
end