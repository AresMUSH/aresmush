module AresMUSH
  class PluginFactory
    
    attr_accessor :container
    
    def create_plugin_classes
      plugins = []
      find_and_instantiate(AresMUSH, plugins)
      logger.info "System load complete."
      plugins
    end
    
    def find_and_instantiate(mod, plugins)
      consts = mod.constants
      logger.debug "Searching #{mod}."
      consts.each do |c|
        sym = mod.const_get(c)
        if (sym.class == Module)
          find_and_instantiate(sym, plugins)
        else
          if (sym.class == Class && sym.include?(AresMUSH::Plugin))
            logger.debug "Creating #{sym}."
            plugins << sym.new(@container)            
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