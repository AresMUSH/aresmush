module AresMUSH
  class OnOffOption
    attr_accessor :value
    
    def initialize(value)
      self.value = !value ? nil : value.strip.downcase
    end
    
    def self.values
      ['on', 'off']
    end
    
    def validate
      return t('dispatcher.invalid_on_off_option') if !OnOffOption.values.include?(self.value)
      return nil
    end
    
    def to_s
      self.value
    end
    
    def is_on?
      self.value == "on"
    end
  end
end