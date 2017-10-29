require 'i18n'

module AresMUSH  
  module LocaleLoader
    
    def self.load_dir(dir)
      return unless Dir.exist?(dir)
      Dir.foreach(dir) do |f| 
        load_file File.join(dir, f)
      end
    end
    
    def self.load_files(files)
      files.each do |f|
        load_file(f)
      end
    end
    
    def self.load_file(file_path)
      return if File.directory?(file_path)
      Global.logger.debug("Loading translations from #{file_path}.")
      I18n.load_path << file_path
    end
  end
end
