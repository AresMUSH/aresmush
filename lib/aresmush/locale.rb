# This class is inspired by the Ruby i18N library, but I had slightly different needs.
  
# Short global alias for translate and localize
def t(str, *args)
  AresMUSH::Locale.instance.translate(str, *args)
end

def l(object, options = {})
  AresMUSH::Locale.instance.localize(object)
end
  
module AresMUSH  
  
  
  class Locale
    def initialize(config_reader, path)
      @path = path
      @config_reader = config_reader
      @locale = "en"
      @fallback_locale = "en"
      @translations = {}
      @@instance = self
    end
    
    attr_reader :locale, :fallback_locale
    
    # Default locale instance - for test purposes
    @@instance =  Locale.new(nil, "")

    def self.instance
      @@instance
    end
    
    def setup
      load_translations
      set_locale
    end
    
    def localize(object, options = {})
      if (object.is_a?(Date) || object.is_a?(Time))
        raise "Localizing dates and times is not currently supported."
      else
        sep = t('number.separator')
        object.to_s.gsub(/\./, sep)
      end
    end
    
    def delocalize(object, options = {})
      if (object.is_a?(Date) || object.is_a?(Time))
        raise "Delocalizing dates and times is not currently supported."
      else
        sep = t('number.separator')
        object.to_s.gsub(/#{sep}/, ".")
      end
    end
    
    def translate(str, *args)
      
      translation = lookup_translation(@locale, str)
      
      if (translation.nil?)
       translation = lookup_translation(@fallback_locale, str) 
      end
      
      if (translation.nil?)
       translation = str
      end
      
      substitute_vars(translation, *args)
    end
    
    private
    
    def lookup_translation(locale, key)
      return nil if !@translations.has_key?(locale)
      keys = key.to_s.split('.')
      tmp_hash = @translations[locale]
      while (k = keys.shift)
        if (tmp_hash.has_key?(k))
          tmp_hash = tmp_hash[k]
        else
          return nil
        end
      end
      tmp_hash
    end
    
    def substitute_vars(str, *args)
      str.gsub(/%{.*?}/) do |key|
         key = key.gsub('%', '')
         key = key.gsub('{', '')
         key = key.gsub('}', '')
         args[0][:"#{key}"]
      end
    end

    def load_translations
      @translations = YamlExtensions.one_yaml_to_rule_them_all("#{@path}")
    end
    
    def set_locale
      @locale =  @config_reader.config['server']['locale']
      @fallback_locale =  @config_reader.config['server']['fallback_locale']
    end
  end
end
