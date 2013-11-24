module AresMUSH
  class CommandCracker
    
    # Decodes commands in the standard form:
    #   root[/switch][ args]
    #   root[args, when args starts with a number]
    # Anything not found will be nil
    
    def self.crack(input)
      cracked = /^(?<root>[^\d\s\/]+)(?<switch>\/[^\s]+)*(?<args>.+)*/.match(input.strip)
      root = cracked[:root].nil? ? nil : cracked[:root].strip
      switch = cracked[:switch].nil? ? nil : cracked[:switch].rest("/")
      args = cracked[:args].nil? ? nil : cracked[:args].strip
      
      {
        :root => root,
        :switch => switch,
        :args => args
      }
    end
    
  end
end