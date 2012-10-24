module AresMUSH
  class SystemFactory
    
    attr_accessor :container
    
    def create_system_classes
      consts = AresMUSH::Commands.constants
      systems = []
      consts.each do |c|
        instance = AresMUSH::Commands.const_get(c).new(@container)
        puts "Loading " + instance.class.name
        systems << instance
      end
      systems
    end
  end
end