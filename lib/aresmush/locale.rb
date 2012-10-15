require "i18n"
require "i18n/backend/fallbacks" 

# Short global alias for i18N.t
def t(str, *args)
  I18n.t(str, *args)
end

def l(object, options = {})
  I18n.l(object, options)
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
      enable_fallbacks
    end
    
    private
    def set_load_path
      I18n.load_path = []
      Dir.foreach("#{@path}") do |f| 
        file_path = "#{@path}/#{f}"
        next if (File.directory?(file_path))
        I18n.load_path << file_path
      end
    end
    
    def set_locale
      I18n.locale =  @config_reader.config['server']['locale']
    end
    
    def enable_fallbacks
      I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
      I18n.default_locale = "en"
    end
  end
end
