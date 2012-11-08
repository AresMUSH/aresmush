module AresMUSH
  class AddonFactory
    
    attr_accessor :container
    
    def create_addon_classes
      consts = AresMUSH::EventHandlers.constants
      addons = []
      consts.each do |c|
        instance = AresMUSH::EventHandlers.const_get(c).new(@container)
        logger.debug "Loaded " + instance.class.name
        addons << instance
      end
      logger.info "System load complete."
      addons
    end
  end
end