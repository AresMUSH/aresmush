require "i18n"

def _t(str, *args)
  I18n.t(str, *args)
end
  
module AresMUSH  
  class Locale
    def initialize(config_reader, path)
      @path = path
      @config_reader = config_reader
    end
    
    def setup
      set_load_path
      set_locale
    end
    
    private
    def set_load_path
      Dir.foreach("#{@path}") do |f| 
        file_path = "#{@path}/#{f}"
        next if (File.directory?(file_path))
        I18n.load_path << file_path
      end
    end
    
    def set_locale
      I18n.locale =  @config_reader.config['server']['locale']
    end
  end
end
