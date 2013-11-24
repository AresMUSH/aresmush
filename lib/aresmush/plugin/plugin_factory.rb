module AresMUSH
  class PluginFactory
            
    def create_plugin_classes
      plugins = []
      find_and_instantiate(AresMUSH, plugins)
      Global.logger.info "System load complete."
      plugins
    end
    
    def find_and_instantiate(mod, plugins)
      consts = mod.constants
      Global.logger.debug "Searching #{mod}."
      consts.each do |c|
        sym = mod.const_get(c)
        if (sym.class == Module)
          find_and_instantiate(sym, plugins)
        else
          if (sym.class == Class && sym.include?(AresMUSH::Plugin))
            Global.logger.debug "Creating #{sym}."
            plugins << sym.new         
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