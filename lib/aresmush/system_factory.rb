module AresMUSH
  class SystemFactory
    
    attr_accessor :container
    
    def create_system_classes
      consts = AresMUSH::EventHandlers.constants
      systems = []
      consts.each do |c|
        instance = AresMUSH::EventHandlers.const_get(c).new(@container)
        logger.debug "Loaded " + instance.class.name
        systems << instance
      end
      logger.info "System load complete."
      systems
    end
  end
end