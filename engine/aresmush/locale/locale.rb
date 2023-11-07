# Short global alias for translate and localize
def t(str, **args)
  AresMUSH::Locale.translate(str, **args)
end

def l(object, **options)
  AresMUSH::Locale.localize(object, **options)
end
  
module AresMUSH  
  
  class Locale
        
    def self.locale_path
      File.join(AresMUSH.engine_path, "locales")
    end
    
    def locale
      I18n.locale
    end
    
    def default_locale
      I18n.default_locale
    end
    
    # Returns the current locale first, followed by the default locale if it's different.
    def locale_order
      current_locale = Global.read_config("locale", "locale")
      default = Global.read_config("locale", "default_locale")
      locales = [current_locale]
      if (current_locale != default)
        locales << default
      end
      locales
    end
    
    def setup
      reset_load_path
      set_locale
      reload
    end
    
    def self.translate(str, **args)  
      begin
        I18n.t(str, **args)
      rescue I18n::InvalidLocaleData => ex
        I18n.load_path.delete ex.filename
        Global.logger.error "Error in translations file! #{ex}"
        "%xh%xrOops!  Something's wrong with one of the language files.  Please inform the admins: #{ex.filename}.%xn"
      end
    end
    
    def self.localize(object, **args)
      if (object.is_a?(Date) || object.is_a?(Time))
        I18n.l(object, **args)
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
    
    def reset_load_path
      I18n.load_path = []
      locale_order.each do |locale|
        add_locale_file File.join(Locale.locale_path, "locale_#{locale}.yml")
      end
    end
    
    def reload
      I18n.reload!      
    end    
        
    def add_locale_file(file)
      LocaleLoader.load_file file
    end
    
    private
        
    def set_locale
      I18n.locale =  Global.read_config("locale", "locale")
      I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
      I18n.default_locale = Global.read_config("locale", "default_locale")
    end    
  end
end
