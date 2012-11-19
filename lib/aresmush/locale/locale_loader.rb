require 'I18n'

module AresMUSH  
  module LocaleLoader

    def self.load_plugin_locales(plugin_path)
      plugin_dirs = find_plugin_dirs(plugin_path)
      plugin_dirs.each do |d|
        locale_dir = File.join(d, "locales")
        load_dir(locale_dir)
      end
    end
    
    def self.find_plugin_dirs(plugin_path)
      Dir.glob(File.join(plugin_path, "*")).select {|f| File.directory? f}
    end
    
    def self.load_dir(dir)
      return unless Dir.exist?(dir)
      logger.debug("Loading translations from #{dir}.")
      Dir.foreach("#{dir}") do |f| 
        load_file File.join(dir, f)
      end
    end
    
    def self.load_file(file_path)
      return if File.directory?(file_path)
      I18n.load_path << file_path
    end
  end
end
