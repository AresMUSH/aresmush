module AresMUSH
  class AddonFactory
    
    attr_accessor :container
    
    def create_addon_classes
      addons = []
      find_and_instantiate(AresMUSH, addons)
      logger.info "System load complete."
      addons
    end
    
    def find_and_instantiate(mod, addons)
      consts = mod.constants
      logger.debug "Searching #{mod}."
      consts.each do |c|
        sym = mod.const_get(c)
        if (sym.class == Module)
          find_and_instantiate(sym, addons)
        else
          if (sym.class == Class && sym.include?(AresMUSH::Addon))
            logger.debug "Creating #{sym}."
            addons << sym.new(@container)            
          end
        end        
      end
    end
    
    # Taken from ActiveRecord
    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
    
  end
end