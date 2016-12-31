module AresMUSH
  class CommandArgParser
    
    # Decodes commands in the standard form:
    #   root[/switch][ args]
    #   root[args, when args starts with a number]
    # Anything not found will be nil
    
    def self.crack(input)
      cracked = /^(?<prefix>[\/\+\=\@\&]?)(?<root>[^\d\s\/]+)(?<page>[\d]*)?(?<switch>\/[^\s]+)*(?<args>.+)*/.match(input.strip)

      if (!cracked)      
        # Never allow root to be nil
        return { :prefix => nil, :root => input.chomp, :page => 1, :switch => nil, :args => nil }
      end

      prefix = cracked[:prefix].empty? ? nil : cracked[:prefix].strip
      page = cracked[:page].empty? ? 1 : cracked[:page].strip.to_i
      root = cracked[:root].nil? ? input.chomp : cracked[:root].strip
      switch = cracked[:switch].nil? ? nil : cracked[:switch].rest("/")
      args = cracked[:args].nil? ? nil : cracked[:args].strip

      {
        :prefix => prefix,
        :root => root,
        :page => page,
        :switch => switch,
        :args => args
      }
    end
    
    def self.strip_prefix(str)
      !str ? nil : str.sub(/^[\/\+\=\@\&]/, '')
    end
    
  end
end