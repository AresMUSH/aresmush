module AresMUSH
  class EmojiFormatter
    def self.format(msg)
      formatted = msg
      smileys = Global.read_config('emoji', 'smileys') || {}
      
      smileys.each do |text, emoji|
        formatted = (formatted.gsub(/(^|\s)#{Regexp.escape(text)}($|\s|[.?,!\"])/) { "#{$1}:#{emoji}:#{$2}" })
      end
         
      formatted.gsub(/(^|[^`]):([^ :]+):/) { "#{$1}#{find_emoji($2)}" }
    end
    
    def self.find_emoji(name)
      return "" if !name
      
      all_nicks = Global.read_config('emoji', 'aliases') || {}
      nick = all_nicks.keys.select { |k| k.downcase == name.downcase }.first
      
      if (nick)
        name = all_nicks[nick]
      end
      
      all_emoji = Global.read_config('emoji', 'emoji') || {}
      key = all_emoji.keys.select { |k| k.downcase == name.downcase }.first
      
      if (key)
        print_emoji(all_emoji[key])
      else
        ":#{name}:"
      end
    end
    
    def self.print_emoji(val)
      val.hex.chr(Encoding::UTF_8)
    end
    
    def self.emoji_regex
      all_emoji = Global.read_config("emoji", "emoji").values.map { |v| "\\u\{#{v}\}" }.join('|')
      /([#{all_emoji}])/
    end
  end
end