# Short global alias for translate and localize
def t(str, *args)
  AresMUSH::Locale.translate(str, *args)
end

def l(object, options = {})
  AresMUSH::Locale.localize(object, options)
end
  
module AresMUSH  
  
  class Locale
    def initialize(config_reader)
      @config_reader = config_reader     
    end
        
    def self.locale_path
      File.join(AresMUSH.game_path, "locales")
    end
    
    def locale
      I18n.locale
    end
    
    def default_locale
      I18n.default_locale
    end
    
    def setup
      load!
      set_locale
    end
    
    def self.translate(str, *args)  
      I18n.t(str, *args)
    end
    
    def self.localize(object, *args)
      if (object.is_a?(Date) || object.is_a?(Time))
        I18n.l(object, *args)
      else
        sep = t('number.format.separator')
        object.to_s.gsub(/\./, sep)
      end
    end
    
    def delocalize(object, options = {})
      if (object.is_a?(Date) || object.is_a?(Time))
        # Not current supported
        object.to_s
      else
        sep = t('number.format.separator')
        object.to_s.gsub(/#{sep}/, ".")
      end
    end
    
    def load!
      I18n.load_path = []
      LocaleLoader.load_dir(Locale.locale_path)
      plugin_locales = PluginManager.locale_files
      LocaleLoader.load_files(plugin_locales)
      I18n.reload!      
    end
    
    private
        
    def set_locale
      I18n.locale =  @config_reader.config['server']['locale']
      I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
      I18n.default_locale = @config_reader.config['server']['default_locale']
    end    
  end
end
