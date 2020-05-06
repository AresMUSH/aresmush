module AresMUSH
  module Utils
    class EmojiListRequestHandler
      def handle(request)
        allowed = Global.read_config('emoji', 'allow_emoji')
        
        if (allowed)
          aliases = (Global.read_config('emoji', 'aliases') || {}).map { |k, v|
            { 
              name: k,
              display: EmojiFormatter.format(":#{v}:")
            }
          }
          smileys = (Global.read_config('emoji', 'smileys') || {}).map { |k, v|
            { 
              name: k,
              display: EmojiFormatter.format(":#{v}:")
            }
          }
            
          emoji = (Global.read_config('emoji', 'emoji') || {}).map { |k, v|
            { 
              name: k,
              code: "U+#{v}",
              display: EmojiFormatter.print_emoji(v)
            }
          }
        else
          smileys = {}
          emoji = {}
        end
        
        {
          aliases: aliases,
          smileys: smileys,
          emoji: emoji,
          allowed: allowed
        }        
      end
    end
  end
end