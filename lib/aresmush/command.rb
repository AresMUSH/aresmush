module AresMUSH
  class Command
    
    attr_accessor :enactor, :raw, :root, :switch, :args
    
    def initialize(client, input)
      @enactor = client.player
      @raw = input.chomp
      crack(input)
    end
    
    def to_s
      "raw=#{@raw} enactor=#{@enactor.nil? ? "nil" : @enactor["name"]}"
    end
    
    def root_is?(root)
      @root == root
    end
    
    def logged_in?
      @enactor != nil
    end
    
    def crack_args(regex)
      @args = regex.match(@args).names_hash
    end
    
    private
    
    # This cracks the two basic command formats
    #   root[/switch][ args]
    #   root[args, when args starts with a number]
    # Anything not found will be nil
    def crack(input)
      cracked = /^(?<root>[^\d\s\/]+)(?<switch>\/[^\s]+)*(?<args>.+)*/.match(input.strip)
      @root = cracked[:root].nil? ? nil : cracked[:root].strip
      @switch = cracked[:switch].nil? ? nil : cracked[:switch].rest("/")
      @args = cracked[:args].nil? ? nil : cracked[:args].strip
    end
  end
end