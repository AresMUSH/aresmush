class Dir
  def self.regular_dirs(path)
    Dir.glob(File.join(path, "*")).select {|f| File.directory? f}
  end
  
  def self.regular_files(path)
    Dir.glob(File.join(path, "*")).select {|f| !File.directory? f}
  end
end