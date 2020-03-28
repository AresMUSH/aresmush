module AresMUSH
  class ClientDisplaySettings
    attr_accessor :ascii_mode, :color_mode, :screen_reader, :emoji_enabled
    
    def initialize
      self.ascii_mode = false
      self.color_mode = "FANSI"
      self.screen_reader = false
      self.emoji_enabled = true
    end
    
    def self.from_char(char)
      settings = ClientDisplaySettings.new
      return settings if !char
      
      settings.ascii_mode = char.ascii_mode_enabled
      settings.color_mode = char.color_mode
      settings.screen_reader = char.screen_reader
      settings.emoji_enabled = char.emoji_enabled
      settings
    end
    
    def show_emoji
      return false if self.ascii_mode
      return false if self.screen_reader
      return self.emoji_enabled
    end
  end
end