require "i18n"
require "i18n/backend/fallbacks" 

# Short global alias for i18N.t and our own .l wrapper
def t(str, *args)
  I18n.t(str, *args)
end

def l(object, options = {})
  AresMUSH::Locale.localize(object, options)
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
    
    def self.localize(object, options = {})
      if (object.is_a?(Date) || object.is_a?(Time))
        I18n.l(object, options)
      else
        # I18N doesn't handle numbers, so do it manually.
        sep = t('number.format.separator')
        object.to_s.gsub(/\./, sep)
      end
    end
    
    def self.delocalize(object, options = {})
      if (object.is_a?(Date) || object.is_a?(Time))
        raise "Delocalizing dates and times is not currently supported."
      else
        sep = t('number.format.separator')
        object.to_s.gsub(/#{sep}/, ".")
      end
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
