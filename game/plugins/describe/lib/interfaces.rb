module AresMUSH
  module Describe

    def self.interface(plugin_manager)
      plugin_manager.interface("Describe::DescFunctions")
    end
    
    
    
    class DescFunctions 
      include AresMUSH::Plugin
      
      def get_desc(model)
        renderer = DescFactory.build(model, container)
        desc = renderer.render
        Formatter.perform_subs(desc)
      end
      
    end
    
    def self.set_desc(model, desc)  
      logger.debug("Setting desc: #{model["name"]} #{desc}")
      
      model["description"] = desc
      model_class = AresModel.model_class(model)
      model_class.update(model)
    end
    
  end
end
